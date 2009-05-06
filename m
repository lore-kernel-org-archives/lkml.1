Return-Path: <linux-kernel-owner+w=401wt.eu-S1758922AbZEFNS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922AbZEFNS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 09:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759047AbZEFNSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 09:18:15 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:47187 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758964AbZEFNSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 09:18:14 -0400
MIME-Version: 1.0
In-Reply-To: <1241540502.2987.22.camel@localhost.localdomain>
References: <1241540502.2987.22.camel@localhost.localdomain>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 6 May 2009 15:17:52 +0200
Message-ID: <ac3eb2510905060617l708a5024p8f67a90d447a3cae@mail.gmail.com>
Subject: Re: kobject_set_name() uses GFP_KERNEL
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 5, 2009 at 18:21, Marcel Holtmann <marcel@holtmann.org> wrote:
> all the users of kobject_set_name() which includes dev_set_name() are
> allocating their memory for the device name with GFP_KERNEL. It is not a
> big deal since device_add() does the same. However it is not obvious and
> I ran into an issue in the Bluetooth stack where I was setting the
> device name from a context that can't sleep. If this behavior is on
> purpose, we better add an extra comment in the documentation.

It's the entire driver core and kobjects which use GFP_KERNEL, so it
just "happened" for that function too, I guess.

If it helps to documents that, where should it be added? Maybe you can
just send a patch?

Thanks,
Kay
