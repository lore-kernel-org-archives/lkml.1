Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655AbYKMMGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbYKMMGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 07:06:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYKMMG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 07:06:28 -0500
Received: from antispam.upcomillas.es ([130.206.70.245]:42609 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYKMMG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 07:06:27 -0500
X-Greylist: delayed 1819 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Nov 2008 07:06:27 EST
Message-ID: <491C0C31.1090003@upcomillas.es>
Date: Thu, 13 Nov 2008 12:14:57 +0100
From: Romano Giannetti <romanol@upcomillas.es>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Mathieu Chouquet-Stringer <mchouque@free.fr>,
       Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: Re: Suspend to disk broken in latest 2.6.28-rc3
References: <20081109195033.GA1335@mobydick> <20081112184236.GR26778@kernel.dk> <200811122237.03882.rjw@sisk.pl> <200811121357.02233.jbarnes@virtuousgeek.org> <20081113073341.GV26778@kernel.dk> <20081113084144.GX26778@kernel.dk>
In-Reply-To: <20081113084144.GX26778@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jens Axboe wrote:
> On Thu, Nov 13 2008, Jens Axboe wrote:
>> On Wed, Nov 12 2008, Jesse Barnes wrote:

>> Yep, it's intel graphics, sorry I should have mentioned that!
>>
>>> Jens, does suspend/resume work if you just do it from the console
>>> (echo mem > /sys/power/state) with i915 loaded?
>> Let me try that right away.
> 
> Seems to work fine from the console, even with i915 loaded and X on the
> login screen on a different vt.
> 

Isn't a VC switch used on suspend/resume? If yes, this could be an
incarnation of http://bugzilla.kernel.org/show_bug.cgi?id=11947

Romano

-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
