Return-Path: <linux-kernel-owner+w=401wt.eu-S1161237AbXBILZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161237AbXBILZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 06:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946354AbXBILZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 06:25:00 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37897 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161237AbXBILZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 06:25:00 -0500
Subject: Re: -mm merge plans for 2.6.21
From: Arjan van de Ven <arjan@infradead.org>
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <20070209105737.GF5785@slug>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
	 <Pine.LNX.4.61.0702090023270.24888@yvahk01.tjqt.qr>
	 <20070209105737.GF5785@slug>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 09 Feb 2007 12:24:33 +0100
Message-Id: <1171020273.8675.150.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-09 at 10:57 +0000, Frederik Deweerdt wrote:
> +static const int __deprecated SA_INTERRUPT = IRQF_DISABLED;
> +static const int __deprecated SA_SAMPLE_RANDOM = IRQF_SAMPLE_RANDOM;
> +static const int __deprecated SA_SHIRQ = IRQF_SHARED;
> +static const int __deprecated SA_PROBEIRQ = IRQF_PROBE_SHARED;
> +static const int __deprecated SA_PERCPU = IRQF_PERCPU;
> +
> +static const int __deprecated SA_TRIGGER_LOW = IRQF_TRIGGER_LOW;
> +static const int __deprecated SA_TRIGGER_HIGH = IRQF_TRIGGER_HIGH;
> +static const int __deprecated SA_TRIGGER_FALLING = IRQF_TRIGGER_FALLING;
> +static const int __deprecated SA_TRIGGER_RISING = IRQF_TRIGGER_RISING;
> +static const int __deprecated SA_TRIGGER_MASK = IRQF_TRIGGER_MASK;

this will include these in every .o file for which the .c file includes
the header. NOT GOOD(tm)

why not just bite the bullet?
removing version.h also broke the same all external modules, and they
got fixed in days.. no big deal. kernel api change all the time, this
one has been around in "double mode" quite some time...


