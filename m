Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab0BIB5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 20:57:43 -0500
Received: from mail-qy0-f179.google.com ([209.85.221.179]:56547 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab0BIB5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 20:57:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=o9YzFQpzITP1gyiqvBDnZP4yqDt4qMhGdV1wjWmEDFe9txeOucklHP59tfaSv0g+Aw
         fONGeZs8P61CG7tIJN8wMRouzCNPdCo/pyQrt2BdcXiTUDzUyUHyhokmGFEaiOK2cTYd
         hDn30LFo5AJLtGrGp3eqgWObR6osJ0Nmrngdc=
MIME-Version: 1.0
In-Reply-To: <201002082032.58482.rjw@sisk.pl>
References: <20100208185429.GA4765@x200> <201002082032.58482.rjw@sisk.pl>
Date: Tue, 9 Feb 2010 09:57:40 +0800
Message-ID: <2375c9f91002081757r26217bdas9b352f27ad4c5060@mail.gmail.com>
Subject: Re: 2.6.33-rc7-next-20100208: recursive locking in __driver_attach()
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 9, 2010 at 3:32 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Well, I guess sysfs lockdep annotations strike again ...
>

Nope, this is a known issue of core driver code, which is being handled
by Alan Stern.
