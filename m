Return-Path: <linux-kernel-owner+w=401wt.eu-S1753009AbXDRNpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbXDRNpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 09:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbXDRNpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 09:45:17 -0400
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:45464 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbXDRNpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 09:45:15 -0400
Date: Wed, 18 Apr 2007 09:45:11 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Andi Kleen <andi@firstfloor.org>, Casey Schaufler <casey@schaufler-ca.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: AppArmor FAQ
In-Reply-To: <20070417225815.000b0fdb@the-village.bc.nu>
Message-ID: <Line.LNX.4.64.0704180935100.25495@d.namei>
References: <20070417181016.GA10903@one.firstfloor.org>
 <657751.18080.qm@web36614.mail.mud.yahoo.com> <20070417211653.GB11944@one.firstfloor.org>
 <20070417225815.000b0fdb@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007, Alan Cox wrote:

> I'm not sure if AppArmor can be made good security for the general case,
> but it is a model that works in the limited http environment
> (eg .htaccess) and is something people can play with and hack on and may
> be possible to configure to be very secure.

Perhaps -- until your httpd is compromised via a buffer overflow or 
simply misbehaves due to a software or configuration flaw, then the 
assumptions being made about its use of pathnames and their security 
properties are out the window.

Without security labeling of the objects being accessed, you can't protect 
against software flaws, which has been a pretty fundamental and widely 
understood requirement in general computing for at least a decade.


- James
-- 
James Morris
<jmorris@namei.org>
