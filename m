Return-Path: <linux-kernel-owner+w=401wt.eu-S1759538AbYGBMaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538AbYGBMaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 08:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbYGBMaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 08:30:00 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:60924 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbYGBM37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 08:29:59 -0400
Subject: Re: [patch] security: fix dummy xattr functions
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jmorris@namei.org, jjohansen@suse.de, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       serue@us.ibm.com, morgan@kernel.org
In-Reply-To: <E1KE0ub-00087c-Ek@pomaz-ex.szeredi.hu>
References: <E1KDmeW-0006KB-2x@pomaz-ex.szeredi.hu>
	 <Xine.LNX.4.64.0807021604120.26138@us.intercode.com.au>
	 <E1KDwg7-0007OX-5D@pomaz-ex.szeredi.hu>
	 <Xine.LNX.4.64.0807021906350.26138@us.intercode.com.au>
	 <1214999316.22447.240.camel@moss-spartans.epoch.ncsc.mil>
	 <E1KE0ub-00087c-Ek@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 02 Jul 2008 08:28:16 -0400
Message-Id: <1215001696.22447.268.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-07-02 at 13:54 +0200, Miklos Szeredi wrote:
> On Wed, 02 Jul 2008, Stephen Smalley wrote:
> > As discussed elsewhere, the dummy module just needs to die, and
> > capability needs to become the default module.
> 
> How hard would that be to do in your opinion?
> 
> It would help some if we didn't have to update the dummy module with
> the changes required by apparmor.

It shouldn't be difficult (famous last words ;).  And the LSM maintainer
already said he was ok with it,
http://marc.info/?l=linux-kernel&m=121311583732168&w=2

-- 
Stephen Smalley
National Security Agency

