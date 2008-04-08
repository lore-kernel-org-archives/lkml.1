Return-Path: <linux-kernel-owner+w=401wt.eu-S1752964AbYDHMfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbYDHMfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 08:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbYDHMfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 08:35:12 -0400
Received: from ic0245.upco.es ([130.206.70.245]:49251 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbYDHMfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 08:35:10 -0400
Subject: Re: 2.6.25-rc6 regression - hang on resume [Bug 10319]
From: Romano Giannetti <romanol@upcomillas.es>
To: Tino Keitel <tino.keitel@gmx.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Soeren Sonnenburg <kernel@nn7.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org, Jesse Barnes <jesse.barnes@intel.com>,
       suspend-devel@lists.sourceforge.net
In-Reply-To: <20080408085846.GA15403@dose.home.local>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
	 <1207290689.4511.1.camel@localhost> <1207552602.26185.13.camel@pern>
	 <200804071110.39933.rjw@sisk.pl>  <20080408085846.GA15403@dose.home.local>
Content-Type: text/plain; charset=ISO-8859-15
Date: Tue, 08 Apr 2008 14:35:07 +0200
Message-Id: <1207658107.21698.17.camel@pern>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2008-04-08 at 10:58 +0200, Tino Keitel wrote:
> With 2.6.25-rc, the text console is fine after resume, due to the
> recent changes to the Intel i915 DRM driver. Maybe those people who
> used to use vbetool prior to 2.6.25 should check if this is still
> needed.

Yep, the problem is just that: in 2.6.24 vbetool hacks (in my case,
using s2ram -p -m options) was needed to resume graphics. Now they are
not needed anymore, and using them _break_ resume.

So, people with a working suspend-to-ram setup (even using the whitelist
in s2ram, I mean, simply calling s2ram) will discover that 2.6.25 break
their machine. Removing the s2ram package and suspending with
kernel-only machinery will work, but... well, it's not user-friendly.
 
Romano 

-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
