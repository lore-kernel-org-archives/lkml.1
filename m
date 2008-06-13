Return-Path: <linux-kernel-owner+w=401wt.eu-S1757654AbYFMKij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654AbYFMKij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 06:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbYFMKic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 06:38:32 -0400
Received: from ic0245.upco.es ([130.206.70.245]:40049 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbYFMKib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 06:38:31 -0400
Subject: Re: ALC883 recording troubles...
From: Romano Giannetti <romano@dea.icai.upcomillas.es>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
In-Reply-To: <6278d2220806121450h39280637udbe06ffb92fbb0d1@mail.gmail.com>
References: <6278d2220806091259t47c9b070v269da0f5855ef014@mail.gmail.com>
	 <s5habhtesoq.wl%tiwai@suse.de>
	 <6278d2220806111200g4f802885wfc5f0fd6c0405efb@mail.gmail.com>
	 <s5hiqwf0vyr.wl%tiwai@suse.de>
	 <6278d2220806121450h39280637udbe06ffb92fbb0d1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Date: Fri, 13 Jun 2008 12:38:26 +0200
Message-Id: <1213353506.7505.7.camel@pern>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-12 at 22:50 +0100, Daniel J Blueman wrote:
> Another smoking gun, is when changing certain mixer settings (both on
> gnome-mixer and alsamixer), eg playback->front mic amplitude, moving
> the slider up and down, the L/R linking seems to be almost randomly
> unlinked and the other L/R channel jumps to a different value. When
> re-linking the L/R channels, often, it'll unlink again and change both
> value after reading back the change; mute can be erratic too.
> Confirmed with 2.6.26-r5.

This seems: http://bugzilla.kernel.org/show_bug.cgi?id=10300

I do not think it's related, I had the mic problem *before* seeing this.
It's not fixed as 2.6.26-rc5, btw.

Romano 
-- 

Romano Giannetti                            Dep. de Electrónica y Automática
http://www.dea.icai.upcomillas.es/romano    Univ. Pontificia Comillas (MADRID)


--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
