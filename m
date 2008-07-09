Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbYGIUvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbYGIUvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbYGIUv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:51:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48216 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbYGIUv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:51:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch] power, xen64: fix PM_SLEEP build dependencies
Date: Wed, 9 Jul 2008 22:53:09 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Stephen Tweedie <sct@redhat.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
References: <patchbomb.1215554782@localhost> <200807092233.08930.rjw@sisk.pl> <487521F7.6070708@goop.org>
In-Reply-To: <487521F7.6070708@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807092253.10372.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 9 of July 2008, Jeremy Fitzhardinge wrote:
> Rafael J. Wysocki wrote:
> > It does.  And it depends on PM, because HIBERNATION and SUSPEND both depend
> > on PM.
> >   
> 
> OK, so can we change PM_SLEEP to depend on PM && (HIBERNATE || SUSPEND 
> || XEN)?

I'd rather like it to be (HIBERNATE || SUSPEND || (XEN && PM)), but that would be
slightly confusing IMO.
 
> Or I could add a separate XEN_SAVE_RESTORE config which depends on PM, 
> and then we make PM_SLEEP depend on XEN_SAVE_RESTORE.

I prefer this one.

Thanks,
Rafael
