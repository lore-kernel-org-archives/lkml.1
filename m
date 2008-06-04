Return-Path: <linux-kernel-owner+w=401wt.eu-S1759530AbYFDJAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530AbYFDJAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 05:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759143AbYFDJAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 05:00:24 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:16084 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759345AbYFDJAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 05:00:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZfHxDg0lUz1wvImjfS+DNcKQH9xzagEbgxx6/kcim1BWfjs3G/mbLf9zo7bnPHkYgHEe3a9LQF+fwLOyO9AJstEPCWFJ5oFhBm9pq8Aw5VqfIfJAqa1p7mHGfgyF6SPolVKh2WJ1OUS4mcA3i1U6q42XSUyU+HdGuvZdsFr51yo=
Message-ID: <4af2d03a0806040200p473a3958t74dd0c38c67b26f8@mail.gmail.com>
Date: Wed, 4 Jun 2008 11:00:18 +0200
From: "Jiri Slaby" <jirislaby@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: [PATCH 09/10] HID: add compat support
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       "Marcel Holtmann" <marcel@holtmann.org>, linux-kernel@vger.kernel.org,
       anssi.hannula@gmail.com
In-Reply-To: <Pine.LNX.4.64.0806041054460.10085@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210931362-18422-1-git-send-email-jirislaby@gmail.com>
	 <1210931362-18422-2-git-send-email-jirislaby@gmail.com>
	 <1210931362-18422-3-git-send-email-jirislaby@gmail.com>
	 <1210931362-18422-4-git-send-email-jirislaby@gmail.com>
	 <1210931362-18422-5-git-send-email-jirislaby@gmail.com>
	 <1210931362-18422-6-git-send-email-jirislaby@gmail.com>
	 <1210931362-18422-7-git-send-email-jirislaby@gmail.com>
	 <1210931362-18422-8-git-send-email-jirislaby@gmail.com>
	 <1210931362-18422-9-git-send-email-jirislaby@gmail.com>
	 <Pine.LNX.4.64.0806041054460.10085@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2008 at 10:55 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Fri, 16 May 2008, Jiri Slaby wrote:
>
>> Add compat option to hid code to allow loading of all modules on
>> systems which don't allow autoloading because of old userspace.
> [ ... ]
>> +config HID_COMPAT
>> +     bool "Load all HID drivers on hid core load"
>> +     ---help---
>> +     Compatible option for older userspace. If you have system without udev
>> +     support of module loading through aliases and also old
>> +     module-init-tools which can't handle hid bus, choose Y here. Otherwise
>> +     say N. If you say N and your userspace is old enough, the only
>> +     functionality you loose is modules autoloading.
>> +
>> +     If unsure, say N.
>> +
>
> Hi Jiri,

Hi,

> shouldn't we leave this default to 'Y' for quite some time?

This is unnecessary on most configurations, but requisite on old
userspace. I think, we choose options like this to be yes. Please
alter the patch. Thanks.
