Return-Path: <linux-kernel-owner+w=401wt.eu-S1757720AbYHKVTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbYHKVTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 17:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbYHKVTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 17:19:03 -0400
Received: from mail13.ca.com ([141.202.248.42]:44519 "EHLO mail13.ca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbYHKVTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 17:19:00 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Subject: RE: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon access scanning
Date: Mon, 11 Aug 2008 17:18:59 -0400
Message-ID: <2629CC4E1D22A64593B02C43E855530304AE4B80@USILMS12.ca.com>
In-Reply-To: <48A0649B.4010706@sun.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon access scanning
Thread-Index: Acj77nAoABaonr6qSIWaPf0001l1jAABaoJg
References: <20080806105008.GF6477@cs181140183.pp.htv.fi> <200808070349.55882.mdontu@bitdefender.com> <20080806213904.37a33a58@infradead.org> <200808111645.48177.mdontu@bitdefender.com> <20080811065608.44687f65@infradead.org> <48A0649B.4010706@sun.com>
From: "Press, Jonathan" <Jonathan.Press@ca.com>
To: <davecb@sun.com>, "Arjan van de Ven" <arjan@infradead.org>
Cc: =?UTF-8?B?TWloYWkgRG9uyJt1?= <mdontu@bitdefender.com>,
       "Adrian Bunk" <bunk@kernel.org>, <tvrtko.ursulin@sophos.com>,
       "Greg KH" <greg@kroah.com>, <linux-kernel@vger.kernel.org>,
       <linux-security-module@vger.kernel.org>,
       <malware-list@lists.printk.net>
X-OriginalArrivalTime: 11 Aug 2008 21:18:59.0591 (UTC) FILETIME=[DEF15170:01C8FBF7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m7BLJbdq006720

> -----Original Message-----
> From: David.Collier-Brown@sun.com [mailto:David.Collier-Brown@sun.com] On
> Behalf Of David Collier-Brown
> Sent: Monday, August 11, 2008 12:11 PM
> To: Arjan van de Ven
> Cc: Mihai DonÈ›u; Adrian Bunk; tvrtko.ursulin@sophos.com; Greg KH; Press,
> Jonathan; linux-kernel@vger.kernel.org; linux-security-module@vger.kernel.org;
> malware-list@lists.printk.net
> Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon access
> scanning
> 
>   Perhaps I could try: the AV folks are trying to prevent the
> execution of either modified normal binaries/files or
> specifically exploit binaries/files, by machines for which the
> files are executable or interpretable.
> 
>   The experience of those communities is predominantly
> with DOS/Windows executables and interpretable files, which
> they have difficulty generalizing from.
> 
>   In principle, they could be targeted at any machine, so any
> mechanisms should be applicable to native executables and
> interpretables as well as foreign ones.


You know, that's actually a very good statement of the model.

I think everyone understands one side of the threat model, that is Linux machines being carriers of infections aimed at other platforms.  There are many ways that such infections can be stored, and many ways in which they can be communicated to the target machines.  There are so many that it would not be effective or efficient for each such transfer application to be able to handle its own malware scanning, which is the short statement of why centralized AV protection with notification assistance from the kernel is appropriate.

So, putting that aside, David's statement is a reasonable summary of the nature of the other side of the model, the native attacks we are trying to protect against.  That is, on any platform, not just Linux, we don't always know ahead of time what kind of attack can be launched and how it would be done.  Experience has shown that no one knows enough about every piece of software on every machine to be able to know ahead of time what vulnerabilities there are that can be exploited.  Therefore, we adopt a methodology that allows us to be fairly general.  The signature matching approach allows us to find the signatures of either specific exploit binaries or corrupted normal binaries that our collection and research activities have identified as malware.

It is true that most of our experience is with DOS and Windows, and that the types of attacks that can be launched there are not easy to generalize to other platforms.  However, that does not mean that non-Windows platforms like Linux are therefore immune, or that we are tilting at windmills to say that we address non-Windows infections.  There are many specific forms of malware on non-Windows platforms that we identify in the same way that we identify them on Windows.

In a sense the reason I have found the question about "threat model" to be so difficult to answer is that the basic unpredictability of the attack makes the answer in essence:  "Anything".  That is, it essentially doesn't matter what the threat is or how malware is implemented, except that we know that it exists, both in theory and in practice, and we have an effective way of detecting and removing it.


Jon Press

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
