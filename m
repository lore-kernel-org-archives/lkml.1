Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbZEZIxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbZEZIxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 04:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbZEZIx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 04:53:27 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:23375 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbZEZIx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 04:53:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=cONzWyCFM1Egsw8WvDK+ZofcZwvTjUnFgE2uLDBgqiVOgoq7pvxWr4mdH+bTHuty6/
         1yyWAijRaE5QdgasGVttyuHChJEiIij3yFcuqK5ewPPWmL+vspEyNEaGYQMiPdec7trf
         RjxQ/05uUWgvdfFZtMI9OcajmbydseFrHy4uM=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 26 May 2009 01:53:07 -0700
Message-ID: <43e72e890905260153q59c76842ueb967459bc7353ee@mail.gmail.com>
Subject: ALSA/sound compatibilty package for older kernels
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Tim Gardner <tim.gardner@canonical.com>,
       "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
       Hauke Mehrtens <hauke@hauke-m.de>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In spirit with the compat-wireless-2.6 stable releases [1], here is an
initial attempt at compat-sound-2.6 [2] which allows you to compile
and install the latest ALSA/sound drivers on kernels >= 2.6.27. I only
enabled snd_hda_intel as that is what I have home and was able to test
so far. I actually only tested this on 2.6.28 so far. Patches are
welcomed to enable new drivers as they get tested, please use the git
tree for that [3].

[1] http://wireless.kernel.org/en/users/Download/stable/
[2] http://www.kernel.org/pub/linux/kernel/people/mcgrof/compat-sound-2.6/2009-05-26/compat-sound-2.6.tar.bz2
[3] git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-sound-2.6.git

  Luis
