Return-Path: <linux-kernel-owner+w=401wt.eu-S1760862AbYJKWE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760862AbYJKWE4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 18:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbYJKWEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 18:04:48 -0400
Received: from gw.goop.org ([64.81.55.164]:40712 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338AbYJKWEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 18:04:47 -0400
Message-ID: <48F122FC.6040107@goop.org>
Date: Sat, 11 Oct 2008 15:04:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>
CC: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 42/42] ext4: Rename ext4dev to ext4
References: <1223525160-9887-1-git-send-email-tytso@mit.edu> <1223525160-9887-26-git-send-email-tytso@mit.edu> <1223525160-9887-27-git-send-email-tytso@mit.edu> <1223525160-9887-28-git-send-email-tytso@mit.edu> <1223525160-9887-29-git-send-email-tytso@mit.edu> <1223525160-9887-30-git-send-email-tytso@mit.edu> <1223525160-9887-31-git-send-email-tytso@mit.edu> <1223525160-9887-32-git-send-email-tytso@mit.edu> <1223525160-9887-33-git-send-email-tytso@mit.edu> <1223525160-9887-34-git-send-email-tytso@mit.edu> <1223525160-9887-35-git-send-email-tytso@mit.edu> <1223525160-9887-36-git-send-email-tytso@mit.edu> <1223525160-9887-37-git-send-email-tytso@mit.edu> <1223525160-9887-38-git-send-email-tytso@mit.edu> <1223525160-9887-39-git-send-email-tytso@mit.edu> <1223525160-9887-40-git-send-email-tytso@mit.edu> <1223525160-9887-41-git-send-email-tytso@mit.edu> <1223525160-9887-42-git-send-email-tytso@mit.edu> <1223525160-9887-43-git-send-email-tytso@mit.edu>
In-Reply-To: <1223525160-9887-43-git-send-email-tytso@mit.edu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Ts'o wrote:
> The ext4 filesystem is getting stable enough that it's time to drop
> the "dev" prefix.  Also remove the requirement for the TEST_FILESYS
> flag.
>   

Shouldn't you still register "ext4dev" as a filesystem type, so that old 
setups won't suddenly break?  I just had this happen to me; I had to 
work out why /home didn't mount.

> +obj-$(CONFIG_EXT4_FS)		+= ext4/ # Before ext2 so root fs can be ext4dev
>   

s/ext4dev/ext4/

    J
