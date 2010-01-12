Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218Ab0ALQst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab0ALQst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 11:48:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149Ab0ALQss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 11:48:48 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:39347 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab0ALQss convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 11:48:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=KowO5MD6k49RsOBHWtKi+8ZDPppKEBcbzhAp+1CPNCVsEkmNJMjxNSY8rdF9ngKooF
         ik8ZpX91vPU0LBFyTfY7ziDK23b35qmKAvDcDt7HDn2GtrmbzPekH9VPD5vfthR+PYQz
         JYMEJF345XKO7Nv3P3AzLWdjxlTfd3FyB2Y1k=
MIME-Version: 1.0
In-Reply-To: <1dec3f771001120819x2e9cad5dxf110952cc1347b92@mail.gmail.com>
References: <1dec3f771001120819x2e9cad5dxf110952cc1347b92@mail.gmail.com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Tue, 12 Jan 2010 11:48:25 -0500
Message-ID: <3e8340491001120848x6b892403m6f04ea1fc5c9d06d@mail.gmail.com>
Subject: Re: dlopen in kernel mode
To: mojtaba <kernelppc@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 11:19 AM, mojtaba <kernelppc@gmail.com> wrote:
> [please cc kernelppc@gmail.com]
> Dear all,
>
> Are there any alternatives for dlopen(), dlsym() and dlclose() in
> kernel mode? Basicly, I need to load an executable object file  and
> execute an specific function in it.

You could create a kernel module; but the .so files used in userspace,
in general, cannot be loaded.
