Return-Path: <linux-kernel-owner+w=401wt.eu-S934672AbXGYTpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934672AbXGYTpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 15:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755561AbXGYTpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 15:45:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:33526 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbXGYTpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 15:45:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=P1Oju1iKsifzNA1L0HwmzzmFdBAqj4v0QDyV9gwCGvzHRbX5VgRlKOe5XeohdAN/4WwURbmmw6WpJcUicN5izjUelNx77YREjhKlG+oEzxLnhOy/3C0upgiHn7iUV+Mc8C1PgUaoSy9p3r0OWtBvdLq6vFH7gAV+z1s6m/DjxiM=
Message-ID: <a4e6962a0707251245i642eaf90jc7ccc30870958fa3@mail.gmail.com>
Date: Wed, 25 Jul 2007 14:45:38 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Latchesar Ionkov" <lucho@ionkov.net>
Subject: Re: net/9p/mux.c: use-after-free
Cc: "Adrian Bunk" <bunk@stusta.de>, v9fs-developer@lists.sourceforge.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <f158dc670707251213i65501f9eh6d35a8712583cd90@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070723012014.GV26212@stusta.de>
	 <a4e6962a0707251143ie0b0ce8s7d4a9078fed7eb26@mail.gmail.com>
	 <f158dc670707251213i65501f9eh6d35a8712583cd90@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/07, Latchesar Ionkov <lucho@ionkov.net> wrote:
> Yep, it's a leak.
>

Okay, I'll roll that into the patch as well.

           -eric
