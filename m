Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbXFURYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbXFURYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbXFURY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:24:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:37792 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbXFURYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:24:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DJxhf5nlKcXd2THP086HgkJCyDYPcU4fgeJAEHnQQv+LC+xbHFn3Ia01L4euLqxtNTmPpeSEX3ce+OQScSXdiJSjM+Jcwm0ZWig9q3NIFjh+2wHR9IT/QOsf3BdyOYasf/QfxkSfmKy7WfDjrkPtPX/zVcdqA4wZKjse5/W8Uyo=
Message-ID: <d120d5000706211024m5a8439fcif7912a13c1e461c7@mail.gmail.com>
Date: Thu, 21 Jun 2007 13:24:20 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Benedikt Spranger" <b.spranger@linutronix.de>
Subject: Re: [PATCH] simplify touchscreen event dispatcher
Cc: "linux-kernel @ vger. kernel. org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070621191530.75b0a9a6.b.spranger@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070621191530.75b0a9a6.b.spranger@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benedikt,

On 6/21/07, Benedikt Spranger <b.spranger@linutronix.de> wrote:
> Fix the reporting order of BTN_TOUCH to coordinates first, then
> BTN_TOUCH. This simplifies touchscreen event dispatcher. The userspace
> should count on the kernel and get BTN_TOUCH-events with updated
> coordinates.
>

Why is this needed? In fact, I think that original way is better - you
can ignore coordinate events until you get BTN_TOUCH event. You do
rely on EV_SYN/SYN_REPORT to indicate end of the state transmission,
don't you?

-- 
Dmitry
