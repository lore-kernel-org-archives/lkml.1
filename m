Return-Path: <linux-kernel-owner+w=401wt.eu-S1759459AbZELP4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459AbZELP4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755112AbZELP4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:56:08 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:17085 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbZELP4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:56:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=d1ApsOwjhICxWhZfGNJLUAKIUI13C3sfXHhpShFt+BXKn2M4IEh86SiYw7D+vQ7PzM
         ORBrBS2VqNUuYjN2n1IdzEKnKBnhbfjdEneotMrm7zWjyfbY3Nz6abX+Suym0QLY4hUd
         7kp90xuzuciV8TMZUmmBEjS2bq6L3H8AluEJU=
MIME-Version: 1.0
In-Reply-To: <20aa8c370905120847j4b19175akbdcafc0db2004567@mail.gmail.com>
References: <20aa8c370905120847j4b19175akbdcafc0db2004567@mail.gmail.com>
Date: Tue, 12 May 2009 11:56:03 -0400
Message-ID: <3e8340490905120856w62c6c5cexa247937bf7e84002@mail.gmail.com>
Subject: Re: Help to edit inode content
From: Bryan Donlan <bdonlan@gmail.com>
To: ranjith kannikara <ranjithkannikara@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 11:47 AM, ranjith kannikara
<ranjithkannikara@gmail.com> wrote:
> Hi,
> I am a computer science engineering student. We have started a project
> to make an application to recover deleted files from an ext3
> filesystem. For that we have a doubt . Can we edit the inode content?
> ie the recovery will be robust if we could edit the inode contents and
> give the pointer address manually or through a code. The inode is
> being created in the kernel mode and is it possible to edit those
> contents if the code is allowed to have the kernel mode permissions..?

You'd probably be best off doing this in userspace, with the
filesystem unmounted.
Generally speaking, don't attempt to alter the filesystem from
userspace while it is mounted.
