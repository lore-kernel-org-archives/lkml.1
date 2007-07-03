Return-Path: <linux-kernel-owner+w=401wt.eu-S1758813AbXGCIPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813AbXGCIPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 04:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755128AbXGCIPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 04:15:09 -0400
Received: from antispam.upcomillas.es ([130.206.70.245]:38944 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbXGCIPI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 04:15:08 -0400
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
From: Romano Giannetti <romanol@upcomillas.es>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
In-Reply-To: <20070703042916.GA17240@srcf.ucam.org>
References: <20070703042916.GA17240@srcf.ucam.org>
Content-Type: text/plain;
	charset=utf-8
Date: Tue, 03 Jul 2007 09:37:04 +0200
Message-Id: <1183448224.12649.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-03 at 05:29 +0100, Matthew Garrett wrote:
> or alternatively we  could do what we do for suspend to RAM on other
> platforms (PPC and APM) and just not use the freezer.

As a data point, I am running with this patch on top of 2.6.21.2 the
last 3+ weeks, with an average of 5/6 STR cycles a day, and had no
problems at all. (Sony vaio pcg-fx701). Just normal work, I didn't try
to stress the thing, but I have quite a few times suspended/resumed over
a big compile without a glitch.

What are the risks of this patch supposed to be?

Romano



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation.

