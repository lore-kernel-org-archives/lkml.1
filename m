Return-Path: <linux-kernel-owner+w=401wt.eu-S1757113AbZASRMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbZASRMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:12:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbZASRLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:11:45 -0500
Received: from smarthost03.mail.zen.net.uk ([212.23.3.142]:55087 "EHLO
	smarthost03.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753166AbZASRLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:11:44 -0500
Subject: Re: [PATCH 2/5] cpumask: Use
	topology_core_cpumask()/topology_thread_cpumask()
From: Ben Hutchings <bhutchings@solarflare.com>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       linux-net-drivers@solarflare.com
In-Reply-To: <20090107195832.601131000@polaris-admin.engr.sgi.com>
References: <20090107195832.265117000@polaris-admin.engr.sgi.com>
	 <20090107195832.601131000@polaris-admin.engr.sgi.com>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Mon, 19 Jan 2009 17:11:37 +0000
Message-Id: <1232385097.31644.14.camel@achroite>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost03-IP: [82.69.137.158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-07 at 11:58 -0800, Mike Travis wrote:
> From: Rusty Russell <rusty@rustcorp.com.au>
> 
> Impact: reduce stack usage, use new cpumask API.
> 
> This actually uses topology_core_cpumask() and
> topology_thread_cpumask(), removing the only users of
> topology_core_siblings() and topology_thread_siblings()
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Mike Travis <travis@sgi.com>
> Cc: linux-net-drivers@solarflare.com
Acked-by: Ben Hutchings <bhutchings@solarflare.com>

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

