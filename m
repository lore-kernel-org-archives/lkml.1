Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbYHNMed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbYHNMed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 08:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbYHNMeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 08:34:24 -0400
Received: from ns.bitdefender.com ([91.199.104.10]:52911 "EHLO
	mail.bitdefender.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbYHNMeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 08:34:23 -0400
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mdontu@bitdefender.com>
Organization: BitDefender
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
Date: Thu, 14 Aug 2008 15:34:15 +0300
User-Agent: KMail/1.9.9
Cc: "Andi Kleen" <andi@firstfloor.org>, peterz@infradead.org,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       hch@infradead.org, viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk,
       arjan@infradead.org
References: <1218645375.3540.71.camel@localhost.localdomain> <200808140318.00740.mihai.dontu@gmail.com> <2629CC4E1D22A64593B02C43E855530304AE4BCA@USILMS12.ca.com>
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304AE4BCA@USILMS12.ca.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200808141534.16200.mdontu@bitdefender.com>
X-BitDefender-Scanner: Clean, Agent: BitDefender qmail 3.0.0 on
 mail.bitdefender.com, sigver: 7.20508
X-BitDefender-Spam: No (0)
X-BitDefender-SpamStamp: v1, build 2.6.17.51688, bayes score: 500(0),
 pbayes score: 0(0), neunet score: 0(0), flags: [VALID_REPLY], total:
 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 August 2008, Press, Jonathan wrote:
> > On Wednesday 13 August 2008, Andi Kleen wrote:
> > > On Wed, Aug 13, 2008 at 12:36:15PM -0400, Eric Paris wrote:
> > >
> > > I miss a clear answer to the question: is this
> > > supposed to protect against malware injected as root or not?
> >
> > I honestly don't think we should worry about root. Sure, if the AV
> > scanner happens to catch something (as a consequence of it's
> > implementation), then very well. But designing an antimalware solution
> > which assumes the root is compromised will throw us into security talks
> > for years and I don't think we'll live to hear the end of them.
> >
> > We should focus on the regular users and fix (if needed) the current
> > userland apps (ie. the ones that need root access to do their job). For
> > anymore than that we'll need a super user that supervises root. And then
> > another one.
>
> I think that some people are missing the important point of Eric's recent
> original statement of the "threat model".  Whether we move further in the
> direction of other security protections or not, we are currently talking
> about providing a mechanism for basic AV product to do their job, and the
> job we are talking about is scanning files when they are about to be used
> and might cause harm, or have just been created and we want to make sure
> they are OK.  That is, the AV products that we are talking about in this
> context don't do anything else other than scan files.

I see. Well, as long as everyone sticks to _just_ the file scan. To be honest, 
the only immediate use of the patch that is/was in question, is a "natural" 
scanner for file servers (Samba, NFS etc). 7v5w7go9ub0o, however, might have 
some more ideas. :)

I admit and I apologize, I got pretty worked up when people started asking 
questions like: "how do we protect the file scanner", when the answer should 
have been obvious: the way we protect any other daemon (service) today, by 
means of chmod/chown.

> With that in mind, there is no difference between scanning files being
> accessed/executed/created by root and the same for any other users.  And in
> fact, to the extent that we claim at all to have a somewhat complete
> protection in that realm, excluding root will completely blow that protect
> out of the water and make it essentially useless.
>
> > I think we need to define the 'desktop user' and provide a decent
> > protection mechanism for his common activities (edit documents, listen
> > music, navigate the web, see movies, run scripts which change the IM
> > status etc). For the rest, there are two possibilities:
> >
> >     1. education (_extremely_ important);
>
> It's like abstinence education...it sounds good, at least to some, but it
> doesn't work.  In a way, that's the whole point.  There are millions of
> users.  It doesn't take many who missed the class to create an outbreak
> that does real damage.  It goes back to the medical analogy.  Do you spray
> the swamps for the mosquitoes that carry Eastern Equine Encephalitis, or do
> you knock on everyone's door and tell them not to go near the swamps, and
> hope that everyone's home when you're in their neighborhood?
>
> > I don't think there will ever be an AV product using the marketing line:
> > "it allows you to run your favorite rootkit and enjoy the pretty text it
> > shows, with no worries".
>
> You are right...  Complete rootkit protection is a whole other area not
> fundamentally addressed by a scan.  So let's not create a straw man about
> the things we don't claim to do and then knock the products because we
> don't do them.

-- 
Mihai Donțu
Again, this mail == my own opinion
