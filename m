Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbZI3ToE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbZI3ToE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 15:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbZI3ToD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 15:44:03 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:54536 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735AbZI3ToC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 15:44:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=LvmovJ8xbke7nJomDCEIEUXH5pwrCFJAPN/KLGnPRfAQxBMgwthiZPuR8vBJrWaG+z
         0ndf+ZFi5NnkGRwSxZS7qi/0DnyFoESmqzvKKpqwXkBvXOp+2XR4BDgEMJf2s6u7yFE+
         6SbftiSvrbRfoAZa9uPLdfSw4AkTepTKThGk0=
MIME-Version: 1.0
In-Reply-To: <a769871e0909301205x771e1fc3y62a25790e1728754@mail.gmail.com>
References: <a769871e0909270527j5d4a6a51ycb5627ebe94704be@mail.gmail.com>
	 <20090928142903.GD17514@mit.edu>
	 <a769871e0909301205x771e1fc3y62a25790e1728754@mail.gmail.com>
Date: Wed, 30 Sep 2009 21:44:04 +0200
Message-ID: <a769871e0909301244nec4764albeb7bf042495cc1e@mail.gmail.com>
Subject: Re: ext4/reiser3/btr directory create/read perf
From: wbrana@gmail.com
To: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 9:05 PM,  <wbrana@gmail.com> wrote:
> I reduced benchmark to 10 directories and executed with strace
I meant 5 directories.

>
> Times with 10000 directories and dir_index enabled
>
> /mnt/md8: 64 kB chunks
> ext4
> void cfs::vdirs_create(): 4996 msec
> void cfs::vdirs_read(): 5100 msec
>

Times with 1000 directories and dir_index enabled
/mnt/md8: 64 kB chunks
reiser3
void cfs::vdirs_create(): 973 msec
void cfs::vdirs_read(): 60 msec
ext4
void cfs::vdirs_create(): 2435 msec
void cfs::vdirs_read(): 3326 msec
btrfs
void cfs::vdirs_create(): 1036 msec
void cfs::vdirs_read(): 155 msec

ext4 was 55 times slower than reiser3 in vdirs_read()
