Return-Path: <linux-kernel-owner+w=401wt.eu-S1754451AbZFBWMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbZFBWMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbZFBWML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:12:11 -0400
Received: from static-ip-85-25-59-232.inaddr.intergenia.de ([85.25.59.232]:45619
	"EHLO smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbZFBWML convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:12:11 -0400
Date: Wed, 3 Jun 2009 00:12:03 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <819818298.20090603001203@eikelenboom.it>
To: linux-kernel@vger.kernel.org
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on nativekernels
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The argument that the 1% perfomance hit for native kernels requires extra work for
package maintainers because they have to make a seperate package for native
(without the performance hit) and a xen version (with paravirt_ops) seems
bogus.

At the moment they also have to provide the 2 packages, 1 native recent
kernel, and 1 older back or forward ported xen kernel (2.6.18 or 2.6.26 for
debian)

So this probably wouldn't change much, although it would be nice for
paravirt_ops to perform like native, i think it shouldn't have to be a show
stopper for inclusion of Xen in mainline.

--
        Sander

