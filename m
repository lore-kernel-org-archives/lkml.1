Return-Path: <linux-kernel-owner+w=401wt.eu-S1757380AbYFLWGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbYFLWGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 18:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbYFLWGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:06:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:47084 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbYFLWGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:06:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TlSZdITw0QBYRPFU1LCLMAJZWDApyEd7otkNfexgpyV0DYR2a3ZplG/pJ8ayI3LU8h
         4gdNHuv4xYlPEhjv+3a/B3BDhSDvGVd/WFlMEejg5iTnTaBX0rcCKYD6t+2zQBNpI7li
         E1eCMEczp/cCPZYbq2HYh43xSRv/YzHm1imXg=
Message-ID: <86802c440806121506o8628227he7522c35d906664b@mail.gmail.com>
Date: Thu, 12 Jun 2008 15:06:32 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: Confusions with reserve_early, reserve_bootmem, e820, efi, ... on x86_64
Cc: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@elte.hu,
       bwalle@suse.de, hannes@saeurebad.de, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, steiner@sgi.com
In-Reply-To: <20080612165252.b7ce6902.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080612050609.88a8cf7f.pj@sgi.com>
	 <86802c440806120525v2da860bfyf05eb8ec6b9943d0@mail.gmail.com>
	 <20080612111943.c140c4cb.pj@sgi.com>
	 <86802c440806121005g42f2e44cxbe5f7bdb06836a1e@mail.gmail.com>
	 <20080612151032.5a59309b.pj@sgi.com>
	 <86802c440806121329s54bb1e6dobaaa15c26e7dc81c@mail.gmail.com>
	 <48519077.2050402@zytor.com> <20080612165252.b7ce6902.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 2:52 PM, Paul Jackson <pj@sgi.com> wrote:
> hpa writes:
>> It's probably safer to reserve the EBDA even with EFI; it's only a page
>> or so so it doesn't matter much.
>
> Reserving EBDA with EFI is fine by what little I know.
>
> But the current code doesn't like it -- if the EFI memmap range is inside
> the EBDA range, then the reserve_early() routine panics with:
>
>    "Overlapping early reservations"
>
> Something needs tweaking here somehow ... and I'm not the one to know what.

what is addr that the EFI memmap should be according to spec?

YH
