Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbYJ1LT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbYJ1LT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 07:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbYJ1LTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 07:19:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:45724 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbYJ1LTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 07:19:51 -0400
Subject: Re: [PATCH] da903x regulator bug fix
From: Liam Girdwood <lrg@kernel.org>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Eric Miao <eric.y.miao@gmail.com>,
       Jonathan Cameron <Jonathan.Cameron@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4906F194.30901@cam.ac.uk>
References: <4901EE0F.5000508@cam.ac.uk> <4905DE3D.1010101@gmail.com>
	 <f17812d70810271801t47830712h431df82baee11654@mail.gmail.com>
	 <f17812d70810271802v75b08712l4ab243802f59ecce@mail.gmail.com>
	 <4906F194.30901@cam.ac.uk>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 11:19:38 +0000
Message-Id: <1225192778.28382.137.camel@dell-desktop.example.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-28 at 11:03 +0000, Jonathan Cameron wrote:
> Changes the device registration part of the probe function to supply the
> regulator device rather than its parent (the mfd device) as this caused
> problems when the regulator core attempted to find constraints associated
> with the regulators.
> 
> Signed-of-by: Jonathan Cameron <jic23@cam.ac.uk>

Thanks, this is more preferable than the first patch. I would ultimately
prefer this regulator to be more like wm8350 in terms of mfd
registration but we are in rc2 so this will have to wait.

Eric, would you like to Ack ?

Thanks

Liam


