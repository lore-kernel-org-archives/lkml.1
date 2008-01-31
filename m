Return-Path: <linux-kernel-owner+w=401wt.eu-S1765914AbYAaJve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765914AbYAaJve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 04:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbYAaJv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 04:51:26 -0500
Received: from ns.suse.de ([195.135.220.2]:45818 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815AbYAaJvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 04:51:25 -0500
To: "Steve French" <smfrench@gmail.com>
Cc: "Jeff Layton" <jlayton@redhat.com>, "Adrian Bunk" <bunk@kernel.org>,
       "Guenter Kukkukk" <linux@kukkukk.com>, samba-technical@lists.samba.org,
       linux-kernel@vger.kernel.org, sfrench@samba.org
Subject: Re: [2.6 patch] remove smbfs
From: Andi Kleen <andi@firstfloor.org>
References: <20080128220835.GF8767@does.not.exist>
	<200801302216.13788.linux@kukkukk.com>
	<20080130174103.17ff8197@tleilax.poochiereds.net>
	<20080130225810.GU29368@does.not.exist>
	<20080130193412.61c6e2e9@tleilax.poochiereds.net>
	<20080131004717.GX29368@does.not.exist>
	<20080130201350.7a576203@tleilax.poochiereds.net>
	<524f69650801301730m42abca6dn76d21fbdddbe89b5@mail.gmail.com>
Date: Thu, 31 Jan 2008 10:51:23 +0100
In-Reply-To: <524f69650801301730m42abca6dn76d21fbdddbe89b5@mail.gmail.com> (Steve French's message of "Wed\, 30 Jan 2008 19\:30\:55 -0600")
Message-ID: <p734pcu5nms.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Steve French" <smfrench@gmail.com> writes:
>
> There are four common issues with mounting to these very old servers:
> 1) remembering to mount specifying lanman security (sec=lanman)
> 2) remembering to specify the netbios name of the server on mount
> (which is often not be the same as its tcp name) - we can make this
> easier in mount.cifs though
> 3) some missing function (mostly relating to converting unix time to
> DOS time for set time functions, although the other way around works)
> 4) working around various server bugs (a surprising number of these)


Could you perhaps just emulate it transparently in user space mount? 

When smbfs is specifies use cifs with the correct legacy options.

-Andi
