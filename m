Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab0BUSwZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 13:52:25 -0500
Received: from mail-gx0-f225.google.com ([209.85.217.225]:34365 "EHLO
	mail-gx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab0BUSwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 13:52:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PaaYNs2ObICAPsBepzqg2wZG8GvFoRhZ1cicmifYLcVqY6NrVWMy4FlN61Ussksu28
         eeOwgL/8DngHNqOalAIqtPje/+OSrKRZhqv1fOVvRpBwcSjEmbI3FDCaSJZChB/8qdfS
         3k4c9fKN9O5CcJ9bQPSi2N7JbDgLjG04uKfH8=
MIME-Version: 1.0
In-Reply-To: <4B8176CC.40506@oracle.com>
References: <1266765484.2192.5.camel@localhost> <4B8176CC.40506@oracle.com>
Date: Mon, 22 Feb 2010 00:14:05 +0530
Message-ID: <3f9a31f41002211044j1757e382hb7d2d013573726e5@mail.gmail.com>
Subject: Re: [PATCH] Re: How to disable configfs_example modules
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Joel Becker <joel.becker@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Randy,

On Sun, Feb 21, 2010 at 11:39 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On 02/21/10 07:18, Jaswinder Singh Rajput wrote:
>> I am trying to build no modules but unfortunately I am getting 3 modules
>> with http://userweb.kernel.org/~jaswinder/Corei7/config-i7-64.txt :
>>
>>   INSTALL Documentation/filesystems/configfs/configfs_example_explicit.ko
>>   INSTALL Documentation/filesystems/configfs/configfs_example_macros.ko
>>   INSTALL drivers/scsi/scsi_wait_scan.ko
>>
>> How can I get rid of configfs_example modules.
>>
>> What is the magic in 'ifneq ($(CONFIG_CONFIGFS_FS),)' :
>
> That just says: if CONFIG_CONFIGFS_FS neq empty_string
>  [where the empty_string is between the ",)"]
>

Thanks for the explanation by disabling CONFIG_CONFIGFS_FS, I get rid
of configfs_example modules. Patch is not required.

Thanks for your help,
--
Jaswinder Singh.
