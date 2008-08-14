Return-Path: <linux-kernel-owner+w=401wt.eu-S1758133AbYHNL66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133AbYHNL66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 07:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbYHNL6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 07:58:50 -0400
Received: from mail14.ca.com ([208.232.182.53]:12531 "EHLO mail14.ca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754661AbYHNL6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 07:58:49 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Subject: RE: [malware-list] TALPA - a threat model?  well sorta.
Date: Thu, 14 Aug 2008 07:58:47 -0400
Message-ID: <2629CC4E1D22A64593B02C43E855530304AE4BCA@USILMS12.ca.com>
In-Reply-To: <200808140318.00740.mihai.dontu@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [malware-list] TALPA - a threat model?  well sorta.
Thread-Index: Acj9oz99vGXJo8vOT2aUJukVGKzVBQAX1g1Q
References: <1218645375.3540.71.camel@localhost.localdomain><20080813181714.GL1366@one.firstfloor.org> <200808140318.00740.mihai.dontu@gmail.com>
From: "Press, Jonathan" <Jonathan.Press@ca.com>
To: <mihai.dontu@gmail.com>, "Andi Kleen" <andi@firstfloor.org>
Cc: <peterz@infradead.org>, <linux-kernel@vger.kernel.org>,
       <malware-list@lists.printk.net>, <hch@infradead.org>,
       <viro@zeniv.linux.org.uk>, <alan@lxorguk.ukuu.org.uk>,
       <arjan@infradead.org>
X-OriginalArrivalTime: 14 Aug 2008 11:58:48.0731 (UTC) FILETIME=[1C8C56B0:01C8FE05]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m7EBx2dq014840

> -----Original Message-----
> From: malware-list-bounces@dmesg.printk.net [mailto:malware-list-
> bounces@dmesg.printk.net] On Behalf Of Mihai Don?u
> Sent: Wednesday, August 13, 2008 8:18 PM
> To: Andi Kleen
> Cc: peterz@infradead.org; linux-kernel@vger.kernel.org; malware-
> list@lists.printk.net; hch@infradead.org; viro@zeniv.linux.org.uk;
> alan@lxorguk.ukuu.org.uk; arjan@infradead.org
> Subject: Re: [malware-list] TALPA - a threat model? well sorta.
> 
> On Wednesday 13 August 2008, Andi Kleen wrote:
> > On Wed, Aug 13, 2008 at 12:36:15PM -0400, Eric Paris wrote:
> >
> > I miss a clear answer to the question: is this
> > supposed to protect against malware injected as root or not?
> 
> I honestly don't think we should worry about root. Sure, if the AV scanner
> happens to catch something (as a consequence of it's implementation), then
> very well. But designing an antimalware solution which assumes the root is
> compromised will throw us into security talks for years and I don't think
> we'll live to hear the end of them.
> 
> We should focus on the regular users and fix (if needed) the current userland
> apps (ie. the ones that need root access to do their job). For anymore than
> that we'll need a super user that supervises root. And then another one.

I think that some people are missing the important point of Eric's recent original statement of the "threat model".  Whether we move further in the direction of other security protections or not, we are currently talking about providing a mechanism for basic AV product to do their job, and the job we are talking about is scanning files when they are about to be used and might cause harm, or have just been created and we want to make sure they are OK.  That is, the AV products that we are talking about in this context don't do anything else other than scan files.

With that in mind, there is no difference between scanning files being accessed/executed/created by root and the same for any other users.  And in fact, to the extent that we claim at all to have a somewhat complete protection in that realm, excluding root will completely blow that protect out of the water and make it essentially useless.


> I think we need to define the 'desktop user' and provide a decent protection
> mechanism for his common activities (edit documents, listen music, navigate
> the web, see movies, run scripts which change the IM status etc). For the
> rest, there are two possibilities:

>     1. education (_extremely_ important);

It's like abstinence education...it sounds good, at least to some, but it doesn't work.  In a way, that's the whole point.  There are millions of users.  It doesn't take many who missed the class to create an outbreak that does real damage.  It goes back to the medical analogy.  Do you spray the swamps for the mosquitoes that carry Eastern Equine Encephalitis, or do you knock on everyone's door and tell them not to go near the swamps, and hope that everyone's home when you're in their neighborhood?


> I don't think there will ever be an AV product using the marketing line: "it
> allows you to run your favorite rootkit and enjoy the pretty text it shows,
> with no worries".

You are right...  Complete rootkit protection is a whole other area not fundamentally addressed by a scan.  So let's not create a straw man about the things we don't claim to do and then knock the products because we don't do them.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
