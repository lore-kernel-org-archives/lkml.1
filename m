Return-Path: <linux-kernel-owner+w=401wt.eu-S1759872AbXLLPrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872AbXLLPrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761140AbXLLPq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:46:56 -0500
Received: from ic0245.upco.es ([130.206.70.245]:59281 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761130AbXLLPqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:46:54 -0500
Subject: Re: [RFT] Port 0x80 I/O speed
From: Romano Giannetti <romanol@upcomillas.es>
To: Rene Herman <rene.herman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <475F1DC6.5090403@keyaccess.nl>
References: <475F1DC6.5090403@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-1
Date: Wed, 12 Dec 2007 10:57:19 +0100
Message-Id: <1197453439.27741.6.camel@rukbat>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2007-12-12 at 00:31 +0100, Rene Herman wrote:
> cc -W -Wall -O2 -o port80 port80.c

On a laptop with a CoreDuo T2080/1.73GHz, but running on battery at 
800 MHz (on-demand):

(0)rukbat:~/tmp% for i in {1..10}; do
sudo ./port80
done
cycles: out 3575, in 2844
cycles: out 3589, in 2923
cycles: out 3672, in 2864
cycles: out 3575, in 2843
cycles: out 3607, in 2859
cycles: out 3623, in 2877
cycles: out 3604, in 2848
cycles: out 3575, in 2849
cycles: out 3598, in 2861
cycles: out 3613, in 2861

With a cpu-hog running, cpufreq reporting 1.73GHz:

 
(0)rukbat:~/tmp% for i in {1..10}; do
sudo ./port80
done
cycles: out 3446, in 2652
cycles: out 3499, in 2668
cycles: out 3395, in 2578
cycles: out 3452, in 2662
cycles: out 3448, in 2662
cycles: out 3622, in 2754
cycles: out 3457, in 2662
cycles: out 3451, in 2660
cycles: out 3581, in 2850
cycles: out 3477, in 2696

HTH,
	Romano 

Romano 

-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
