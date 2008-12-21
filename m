Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbYLUX4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbYLUX4B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 18:56:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbYLUXzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 18:55:51 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:58802 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbYLUXzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 18:55:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:x-x-sender:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type:from;
        b=FXaLbupe45GlBuyTe+sNPH/tKgdUlQoOq3NVl9qgYVzMHE0Q92qUUwsmanIHLr6pqm
         ndcCYh7vWMIgbgXDLN13VTg74JSDv4zH9dnQ0poMe5eHUq9DtqJJb0vUcK9MxYWwkR0H
         etl7roKLg/QPLOo5NytwMOxuIL9MYmwlpOR8c=
Date: Sun, 21 Dec 2008 18:55:31 -0500 (EST)
X-X-Sender: parag@parag-desktop
To: Jiri Kosina <jkosina@suse.cz>
cc: Parag Warudkar <parag.lkml@gmail.com>,
       Anssi Hannula <anssi.hannula@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] USBHID: Make Boot Protocol drivers depend on EMBEDDED
In-Reply-To: <alpine.LNX.1.10.0812212344140.26265@jikos.suse.cz>
Message-ID: <alpine.DEB.2.00.0812211849450.9981@parag-desktop>
References: <f7848160812201911k7988221asd095ce873fd8105f@mail.gmail.com> <20081220221253.e09b1b1f.akpm@linux-foundation.org> <f7848160812202226w1f930c86vfd17a2b0163bfc56@mail.gmail.com> <494E20F7.7050106@gmail.com> <f7848160812210717w5e5cc7a2uc5571710f755ec99@mail.gmail.com>
 <alpine.LRH.1.10.0812211824350.11630@twin.jikos.cz> <alpine.DEB.2.00.0812211441300.7101@parag-desktop> <alpine.LNX.1.10.0812212247090.26265@jikos.suse.cz> <20081221140200.40c1fec1.akpm@linux-foundation.org> <alpine.LNX.1.10.0812212302400.26265@jikos.suse.cz>
 <alpine.DEB.2.00.0812211708450.7101@parag-desktop> <494EC082.2010207@gmail.com> <alpine.DEB.2.00.0812211720050.7101@parag-desktop> <alpine.LNX.1.10.0812212344140.26265@jikos.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Parag Warudkar <parag.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 21 Dec 2008, Jiri Kosina wrote:

> Do they even compile usbmouse and usbkbd?

Turns out they don't (and I thought all distros ship make allmodconfig 
kernels for some reason) - now I will be puzzled for ever as to how did those pre rc-9 
kernels worked without usbmouse being blacklisted. Might be config, might 
be timing, dunno.

Parag
