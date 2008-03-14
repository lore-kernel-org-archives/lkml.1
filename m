Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbYCNI6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbYCNI6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 04:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbYCNI6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 04:58:25 -0400
Received: from antispam.upcomillas.es ([130.206.70.245]:32859 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbYCNI6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 04:58:24 -0400
Subject: Re: fix aperture vs. suspend problem
From: Romano Giannetti <romanol@upcomillas.es>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       linux-kernel@vger.kernel.org, mingo@elte.hu, rjw@sisk.pl,
       len.brown@intel.com, stable@kernel.org
In-Reply-To: <20080313223845.GC8115@elf.ucw.cz>
References: <20080313100531.GA3399@elf.ucw.cz>
	 <20080313153248.f43bbce3.akpm@linux-foundation.org>
	 <20080313223845.GC8115@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Date: Fri, 14 Mar 2008 09:14:23 +0100
Message-Id: <1205482463.4561.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 2008-03-13 at 23:38 +0100, Pavel Machek wrote:
> On Thu 2008-03-13 15:32:48, Andrew Morton wrote:
> > [...] 
> > This is also needed in 2.6.24, perhaps earlier?
> 
> It seems to only trigger on >3GB boxes, during swsusp. People are not
> normally suspending those big boxes. I do not think this is worth
> backporting.

Here vendors are starting to sell x86_64 laptops with 4GB ram in the
*default* configuration --- so I think that yes, it should be
backported, at least to 2.6.24 (which will be heavily shipped by distros
this year, I suppose).

Romano

-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
