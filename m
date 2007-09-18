Return-Path: <linux-kernel-owner+w=401wt.eu-S1758745AbXIRWza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745AbXIRWza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 18:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbXIRWzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 18:55:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50222 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbXIRWzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 18:55:21 -0400
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jelle Foks <jelle@foks.8m.com>
Cc: Markus Rechberger <mrechberger@gmail.com>, Alan Cox <alan@redhat.com>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <46EF8A1F.7040309@foks.8m.com>
References: <46C1BCC5.9090709@amd.com>
	 <d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com>
	 <d9def9db0709121610n1a78225cs26380b7ca586344a@mail.gmail.com>
	 <20070913131353.GB26972@linuxtv.org>
	 <d9def9db0709130712h108c7c1obfe24833f5dc27a1@mail.gmail.com>
	 <46E95C54.4060502@gmail.com>
	 <d9def9db0709130908r6e383c51wd115dd56cfe2beef@mail.gmail.com>
	 <46E99F36.8090809@hauppauge.com>
	 <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com>
	 <20070914135237.GB19311@devserv.devel.redhat.com>
	 <d9def9db0709140918m4eff0fe9if01c3383a3a5c3ce@mail.gmail.com>
	 <46EF8A1F.7040309@foks.8m.com>
Content-Type: text/plain
Date: Tue, 18 Sep 2007 19:56:05 -0300
Message-Id: <1190156165.7883.24.camel@areia>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.91-1mdv2008.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The reason why there is no single 'format conversion library' that
> everybody uses is because of the large differences between requirements
> for such a thing. The line between 'format conversion' and things such
> as a video codec, or image processing is very vague.

Agreed. What I think it should happen is that the userspace library
should focus at the "weird" codecs. E. g. those which uses some sort of
proprietary format. This way, an userspace app may use the userspace
library as a "fallback method" for unknown FOURCC formats. The result
will be probably far away from an optimal result on some cases (since it
probably mean double buffering), but this will at least allow userspace
apps to work. As performance become an issue, the userspace app
developer may use the GPL code at userspace API as a reference to write
a proper optimized format driver for its apps.

Just my 2 cents.

Cheers,
Mauro

