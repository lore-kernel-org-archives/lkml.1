Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbXFXV1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbXFXV1n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 17:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbXFXV1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 17:27:37 -0400
Received: from smtp-out2.libero.it ([212.52.84.42]:58128 "EHLO
	smtp-out2.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbXFXV1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 17:27:36 -0400
X-Scanned: with antispam and antivirus automated system at libero.it
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj0KAE9+fkaXLETW/2dsb2JhbACKH6Mi
Date: Sun, 24 Jun 2007 23:27:34 +0200
From: Salvatore De Paolis <depaolis.salvatore@libero.it>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: pivot_root alternative
Message-ID: <20070624232734.28829225@debian>
Organization: Debian Linux
X-Mailer: Claws Mail 2.9.2cvs72 (GTK+ 2.10.13; i686-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAHlBMVEUAKQB8FQC2NADbSQD6Ygr+dxn/iyn/pkL/ynQAAQDr4pu+AAAAAXRSTlMAQObYZgAAAltJREFUOMtNk81x4zAMhd2CfdujqWQLICgXYILaewTIBcSiKwipCla+puN9FClvMNKMjU94+CF4OBwuy7NZnoWZVb05FBt2f7qPRByCBruBPy0iie16BpjUV9D8ak0HnaBxlh8gR6aekSPoFCu4Ff+alUdyDk+Y4r2BHHPOUTy5q0H2Kc4VJNVHzkmoc7ZzrLEBHSlMy5qY3n0fmKdHA57w57l+jSOzg9BjBx2zHQAEbhb4d+DU2stzTXPYSs35BTwRpFKaJo2o4gWIHN+WFXXFXP2tQeMC39BhtZRTmrWCXsPjue6kKNWIbohxeYH0A9ygDFCyFBSj8gbebrmcSNPHE2ffwDNv84VI2lLo2MB2hEUEJKHx2x6R1xKB6acINyIq6MKyLM+/S4oor9jMVPsIj3XJ6yN+TkULRUndklOPciExCr6epqQ3XyOObsiPVHYNZ6d4ZawRRyraOCUdhl718uWpbuKx8xAqixMGGQNq+qjAGI4PhX/Su4gOPNpzTW7cJWIBiwk5vObcIpAEvll7su+9ent+AT9LwOIE/GT+MDsg7LIwERkSwcobc6pn7jphBeh757zQb2OObRlwXaCDl0Wuo92lyGNpkUIUTLy77BHejMip5fq5ADFrjg14McYHlGkpsKcX6PBNSWIxAhHvzbkBS9biWoarMU7Y9y9AisrfGJNA84K+jw04b6xDXYorK+j+fPzVkpNlABzR/VO2mloEo+nOEt/vs3JVagBKzvfosfeb//v4vQGB0tV2NAaHHraAFuGh5XpfxmpOp/9gpHeMAq2cTLEG/gGlWSVVOcldhwAAAABJRU5ErkJggg==
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi all

i built the kernel with a busybox initramfs which runs from a usb stick. While
i boot i need to mount the real root and i'm using pivot_root.
Pivot_root . old-root return to me an "Invalid argument" error and googling i
found here http://lkml.org/lkml/2005/10/8/17 that pivot_root should be avoided.
I want to ask now what i should do to switch to a real root?

Regards
S.
