Return-Path: <linux-kernel-owner+w=401wt.eu-S1758265AbYF0N0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265AbYF0N0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 09:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbYF0NZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 09:25:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:37670 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbYF0NZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 09:25:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=I0HP7BeWvNFTtILp1wHwXGux9u1RbRqX9wimCuaRDf9jk35XuqpKkcLp7hmxr+c/42
         ErG8okUX2H0DU0dxRstaXLwYgqR+6hS+E/pMiH2vhd1mfyGxdu3ZRP2TJE5cU5bVYlnz
         8fL1NwggjbwipgTUgqIAC1rHkYbGsVVXdl++M=
Message-ID: <e2e108260806270625o44ebe7a0u8250fa0bd5e976bd@mail.gmail.com>
Date: Fri, 27 Jun 2008 15:25:56 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "=?GB2312?B?z8TBwQ==?=" <xiaiaxaxi@sjtu.edu.cn>
Subject: Re: How can I migrate a currently running task?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080627211712.6cto2d1zks848c88@webmail1.sjtu.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080627211712.6cto2d1zks848c88@webmail1.sjtu.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 3:17 PM, 夏亮 <xiaiaxaxi@sjtu.edu.cn> wrote:
> I am working on Intel Duo Core with Linux OS 2.6.21, and I'd like to
> migrate task from one cpu to another cpu.
> In SMP systems, load_balance() function uses move_tasks() to move processes
> from source runqueue to local runqueue, but it does not move a currently
> running task. If I want to migrate a currently running task from source
> runqueue to local runqueue, how can I do? Any suggestion is preferred.

Are you familiar with the glibc pthread_setaffinity_np() function
and/or the sched_setaffinity() system call ?

Bart.
