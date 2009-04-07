Return-Path: <linux-kernel-owner+w=401wt.eu-S1762240AbZDGWqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762240AbZDGWqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 18:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761989AbZDGWqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 18:46:17 -0400
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:30540 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761676AbZDGWqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 18:46:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=5shloUtlxNqT1bRVEuXZju5CRRadbxZKUF9eH7gLoym/wpRHBPt2W4Y9Aqrsnxoei/vm4VOylLYWJllxMGcPFRxrqyukXLklWluXhFmaX6QkKo/whDKV5bgtXy6xeSp0Kf4An+oIMU2FCHJm6SrDR0EuzkeL/c0ms0VVe+QNZLY=  ;
X-YMail-OSG: .X3_FdAVM1kVWrGGiIe9y730qnzgD7huQcTlfTNMGj54r.kXwJuHgccAA7PgO6m4n2FTtFHPhCZNEradUnBzGBa17IG8ClvXVWZtjW32rdOv9pG_CYhescy.clTmENy.OlIxW12xQqzTIJyvk6tAPHO8H2Dc64BPwEPh1zaCFxS8rfz0AVecV2neHX7PtDYNgNg_RmBDiRRt_lonC4KdYsTt4rFhd701asNeCmnMsvlSFQnZvMRtixCZldMFNft5g8S3pikMEUZvQmEwh7prQ70FbJqKT5VVF6d17yJeZndnRzA.C2HI
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Narnakaje, Snehaprabha" <nsnehaprabha@ti.com>
Subject: Re: [PATCH] MTD-NAND: Changes to read_page APIs to support NAND_ECC_HW_SYNDROME mode on TI DaVinci DM355
Date: Tue, 7 Apr 2009 15:46:14 -0700
User-Agent: KMail/1.9.10
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1238601784-9563-1-git-send-email-nsnehaprabha@ti.com> <alpine.LFD.2.00.0904071831550.21577@localhost.localdomain> <7A436F7769CA33409C6B44B358BFFF0CFFAA9253@dlee02.ent.ti.com>
In-Reply-To: <7A436F7769CA33409C6B44B358BFFF0CFFAA9253@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904071546.14898.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 April 2009, Narnakaje, Snehaprabha wrote:
> 
>  I have not sent the actual NAND driver to the linux-mtd yet, since
>  the initial version (supported only 1-bit HW ECC) submitted by David
>  Brownell was still in review (no comments and not approved yet).

It merged to mainline yesterday; should verify on DM6446 EVM.

The funky bits are fortunately limited to the 4-bit ECC support,
which are natural to review/evaluate as deltas on top of that core.
It was easy to tell they would bring out some confusion, which is
a good sign of something that's worth reviewing separately.

And, given the patches I referenced previously ... even those
should only be an issue for large page chips.  (And no DaVinci
board that uses large page chips has hit mainline yet.  Lots of
stuff in the queue for, one hopes, 2.6.31 though.)

- Dave

