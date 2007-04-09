Return-Path: <linux-kernel-owner+w=401wt.eu-S1752149AbXDIAXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbXDIAXd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 20:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbXDIAXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 20:23:33 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:39682 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbXDIAXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 20:23:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ARhfbEedxREoyEjDQWUxq//GARsjEutniRBZ0YqS8HQyccofNwSmlA4Y/28lCP37HiK01mYdeiK0mYbHNmksIyX2XNO8fZrdWNq8BxfKoIrzQdqzwMFFNRPs5egI9H2rKZQp0eoWESTxHMC7z8Kjjp8jP1zLCyybXyKgvODYfOs=
Message-ID: <b647ffbd0704081723y4d9e7263yc5e6a7451ffa7392@mail.gmail.com>
Date: Mon, 9 Apr 2007 02:23:32 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Mike Galbraith" <efault@gmx.de>
Subject: Re: SD scheduler testing hitch
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <b647ffbd0704081714j2af41daaq6643e187b7511b03@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b647ffbd0704040704k2e4b3abcyfadc7662dff37f5b@mail.gmail.com>
	 <20070404141546.GA862@elte.hu>
	 <b647ffbd0704041305t2a140369q56cf9f0746b8fd86@mail.gmail.com>
	 <20070406170319.2c961eba.akpm@linux-foundation.org>
	 <20070407092401.GB16356@elte.hu>
	 <1175962840.10478.49.camel@Homer.simpson.net>
	 <1175966255.11408.5.camel@Homer.simpson.net>
	 <1176019324.8244.6.camel@Homer.simpson.net>
	 <b647ffbd0704081714j2af41daaq6643e187b7511b03@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> [...]
> Well, it's a late hour, so maybe I'm missing something... but it does
> look to be HZ and "will run" time interval related issue. Like
> described in (*). Or maybe we both observe similar situations but have
> different reasons behind them.

I meant that account_user_time() is also called from timer_ISR ->
update_process_times() like scheduler_tick(). So if task's running
intervals are shorter than 1/HZ, it's not always accounted --> so cpu%
may be wrong for such a task...


-- 
Best regards,
Dmitry Adamushko
