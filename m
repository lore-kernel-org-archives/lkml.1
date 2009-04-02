Return-Path: <linux-kernel-owner+w=401wt.eu-S1765446AbZDBWhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765446AbZDBWhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 18:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762077AbZDBWhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 18:37:05 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:51648 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761596AbZDBWhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 18:37:03 -0400
Date: Fri, 3 Apr 2009 09:36:59 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: david@lang.hm
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Theodore Tso <tytso@mit.edu>,
       Sitsofe Wheeler <sitsofe@yahoo.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
Message-ID: <20090402223659.GC6898@brong.net>
References: <200904010002.47077.info@gnebu.es> <49D2A5AB.1090704@ursus.ath.cx> <20090401015010.GB4529@mit.edu> <20090401052050.GA20456@sucs.org> <20090401151219.GA12285@srcf.ucam.org> <20090401173521.GA15423@mit.edu> <20090401174336.GA14726@srcf.ucam.org> <alpine.DEB.1.10.0904021116500.28893@asgard.lang.hm> <20090402182925.GA4502@srcf.ucam.org> <alpine.DEB.1.10.0904021134560.28893@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904021134560.28893@asgard.lang.hm>
Organization: brong.net
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 11:44:20AM -0700, david@lang.hm wrote:
> let's not talk a database here, let's talk something simpler, like a POP3 
> mail client (even though I strongly favor IMAP ;-)
>
> it wants to have the message saved before it deletes it from the server.
>
> how should it try to do this?
>
> the only portable method is to fsync the file after it's written and  
> before sending the delete to the server.
>
> so your mail client _should_ issue fsync calls.
>
> however, some (many, most??) users would probably be willing to loose a  
> little e-mail to gain a significant increase in battery life on their  
> laptops.

Obviously it should do a spamminess test.  If the sender is in your
addressbook/whitelist then fsync it, otherwise if it looks spammy,
don't bother.

Seriously, there's no way of telling which emails are the really
important job offer/flight confirmation/invitation from that really
cute girl you met that one time...

... lots of data is like that.  It's usually not important except
when it really, really is - and the average user don't want to be
babysitting every single decision about importance.

  "Your email program wants to spin up the disk to store a message,
   confirm or deny"

Bron.
