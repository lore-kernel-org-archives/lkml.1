Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbZGVSoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbZGVSoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 14:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbZGVSoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 14:44:07 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:40565 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbZGVSoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 14:44:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=MkJjVxHmJwRovRdRXYTXqkohVka3qFaYYgpEPzEQ6JIOlhmhWCc4TLAlHyQ9J3uTH+
         e6VdUIQdtGbfBdbOwSbDoi5SxnCwmz7F43rVognv+l+Rz0A+KUP7GX55+Dk5a7Klf2t+
         aMsFn0hkl5402Axx0kX6dZBLFsp7u0qJQtphg=
From: Alberto Gonzalez <alberto6674@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Kernel 2.6.30 and udevd problem
Date: Wed, 22 Jul 2009 20:43:56 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.29-ARCH; KDE/4.2.4; x86_64; ; )
Cc: Alberto Gonzalez <alberto6674@gmail.com>, Michal Soltys <soltys@ziu.info>,
       Dave Airlie <airlied@linux.ie>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org
References: <200906280821.58631.info@gnebu.es> <200907221851.20916.info@gnebu.es> <20090722101251.0b6c7300@jbarnes-g45>
In-Reply-To: <20090722101251.0b6c7300@jbarnes-g45>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907222043.57244.info@gnebu.es>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 July 2009 19:12:51 Jesse Barnes wrote:
> Ah I must have been looking at the wrong register.  This one makes it
> look like one of your HDMI hotplug bits is getting stuck (HDMIC in
> particular).  This might not even be wired up on your platform...

Yes, I don't use HDMI, my screen is attached via VGA
>
> This test hack should prevent us from responding to those interrupts...

I've been hitting it hard for over an hour with all the usual tricks to 
trigger it (and a few reboots) and I've been unable to reproduce the problem 
with this patch. Before I could trigger it reliably in a few minutes, so I'm 
pretty sure this patch fixes it. If something new comes up, I'll let you know 
anyway.

Thank you very much!

Regards,
Alberto.
