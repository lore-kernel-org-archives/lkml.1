Return-Path: <linux-kernel-owner+w=401wt.eu-S1753756AbYG3GXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbYG3GXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 02:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbYG3GXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 02:23:16 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:51337 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbYG3GXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 02:23:16 -0400
Date: Wed, 30 Jul 2008 08:23:13 +0200
From: Bastian Blank <waldi@debian.org>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/lpar - defer prefered console setup
Message-ID: <20080730062313.GA26044@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	Michael Ellerman <michael@ellerman.id.au>, linuxppc-dev@ozlabs.org,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20080728185651.GA29530@wavehammer.waldi.eu.org> <1217385291.10646.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1217385291.10646.2.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 12:34:51PM +1000, Michael Ellerman wrote:
> On Mon, 2008-07-28 at 20:56 +0200, Bastian Blank wrote:
>  * add_preferred_console - add a device to the list of preferred consoles.
>  ...
>  * The last preferred console added will be used for kernel messages
>  * and stdin/out/err for init. 
> 
> The last console will be added by the console= parsing, and so that will
> be used. The console we add in the pseries setup is only used if nothing
> is specified on the command line.

Okay, then there is a completely different problem. In the case of
"console=hvc0 console=hvc1" it uses the _first_ add stdin/out bla and
ignores the second one completely.

Bastian

-- 
Four thousand throats may be cut in one night by a running man.
		-- Klingon Soldier, "Day of the Dove", stardate unknown
