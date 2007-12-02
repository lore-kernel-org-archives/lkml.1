Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbXLBQDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbXLBQDb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 11:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885AbXLBQDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 11:03:19 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:24120 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755584AbXLBQDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 11:03:17 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=zhDLREWtBuY+PbH+8Sy7CoVBRjlg4Qhzdz8/XdrpSjmviq7/3ROnuGV5XuzVILZgK5QTOBjG2snD3p/Dhagia0TbysjEiPGUbFPjyFhSGveQs1FBUXW/ejjHFaP1pXHVl2RldsOeAjSXasn6IAxSQSwVuX9IY1ouZuprnGjYGQk=  ;
X-YMail-OSG: cKHz3uMVM1lbyY_xnL2T_DKCdQ1KvBxu2BGafnH.z8vE2anBp30ZbKenXiXTv9d0Glrzo4B7qg--
From: David Brownell <david-b@pacbell.net>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: RTC wakealarm write-only, still has 644 permissions
Date: Sun, 2 Dec 2007 08:03:15 -0800
User-Agent: KMail/1.9.6
Cc: rtc-linux@googlegroups.com, kernel list <linux-kernel@vger.kernel.org>,
       Alessandro Zummo <alessandro.zummo@towertech.it>
References: <20070920103225.GA4410@elf.ucw.cz> <200711301310.40360.david-b@pacbell.net> <20071202113609.GA1796@elf.ucw.cz>
In-Reply-To: <20071202113609.GA1796@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712020803.15621.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 December 2007, Pavel Machek wrote:
> Anyway, with wildcarded dates, no-clobber is a problem -- because you
> need to kill the alarm after you waken up, or it will repeat.

And I've started to fix that problem.  Alarms need to
act only in oneshot mode for other reasons too.

- Dave
