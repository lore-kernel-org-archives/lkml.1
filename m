Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbYA3NiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbYA3NiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbYA3Nhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:37:43 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:45188 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133AbYA3Nhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:37:41 -0500
Date: Wed, 30 Jan 2008 14:37:42 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Jonas Bonn <jonas@southpole.se>, netdev@vger.kernel.org,
       romieu@fr.zoreil.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [SIS190] Constify data marked as __devinitdata
Message-ID: <20080130133742.GA22198@uranus.ravnborg.org>
References: <1201690388-9052-1-git-send-email-jonas@southpole.se> <Pine.LNX.4.64.0801301220570.15249@fbirervta.pbzchgretzou.qr> <20080130112559.GA21346@uranus.ravnborg.org> <Pine.LNX.4.64.0801301429230.15249@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801301429230.15249@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 02:31:05PM +0100, Jan Engelhardt wrote:
> 
> On Jan 30 2008 12:25, Sam Ravnborg wrote:
> >
> >We have just introduced __initconst, __cpuinitconst, __meminitconst
> >for const data.
> >So the patch is wrong.
> 
> Oh joy, more tags. Is it actually possible to combine const
> with __devinitconst now?
> 
> static const uint16_t foo[] __devinitconst = { ... };

Yes, try it.

	Sam
