Return-Path: <linux-kernel-owner+w=401wt.eu-S939501AbXHIMe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939501AbXHIMe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932749AbXHIMet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:34:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:56517 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765364AbXHIMes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:34:48 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Documentation files in html format?
To: Jan Engelhardt <jengelh@computergmbh.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Thu, 09 Aug 2007 14:34:10 +0200
References: <8QdB3-87O-7@gated-at.bofh.it> <8QdUr-5j-11@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1IJ7DO-0000pI-JN@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19+laaiP6zszFt2Pbz2DkbtIOVURIZIQcgPp8o
 IKoR1jrfVTV1bdMfwypryX51TCRl8P4A+R6G2Qa64PqzjhUrzF
 TPCULu8LlklL/9hmQ5q1Q==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@computergmbh.de> wrote:
> On Aug 9 2007 11:31, Stephen Hemminger wrote:

>>Since the network device documentation needs a rewrite, I was thinking
>>of using basic html format instead of just plain text. But since this would
>>be starting an new precedent for kernel documentation, some it seemed
>>like a worthwhile topic for discussion.
>>
>>Advantages of html:
>>  * basic formatting like lists, italics, etc
>>  * easier to integrate into other places and retain formatting
>>  * ability to link documents and to external sources easier
>>
>>Downsides:
>>  * can become too formatted and unclear
> 
> So only use <h1> to <h6>, <p>, <b>, <i>, <u>, <ul>, <ol> and <li>.

I don't think <b> and <i> should be used, instead you should use styles
(<span class="code"> etc). Things like <em> and <strong> should be OK,
if used consistently.

> Perhaps maybe <p class="block"> with .block{text-align:justify;}
> because that looks nice in general.

If you like that, you can say "p {text-align:justify;}" in the default
stylesheet. (And if people would override the alignment, class="block"
would be the wrong name).


BTW: You should not listen to those "frames-are-evil" guys. This will only
force you to include all the navigation code in each page, and having to scroll
beyond a ton of navigation stuff was a major annoyance while trying to read
the selinux docs. Instead, you should e.g. provide an "up", "prev" and "next"
link on each page, and keep the rest in the navigation frame (if needed).
-- 
Top 100 things you don't want the sysadmin to say:
0. I just made an extra 2 meg of space in /,  I stripped /vmunix.
    Oh, so that's why ps doesn't work.
Friﬂ, Spammer: ZJCnAN@mBlrwf80.7eggert.dyndns.org An4grd@Z.7eggert.dyndns.org
