Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbYBKN3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbYBKN3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 08:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbYBKN3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 08:29:02 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:39842 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbYBKN3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 08:29:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mUTnSaRuUW6uQmUn+bJhnjVR5rqfaQADWcK8to5AZ+IvBUaQyf4ojfAsPhzzBH0VcSETTFLnQeYOK0rRuVntMCdP50CaMMQObNvVv/Mw6y/Stx5eN/eB6yxqe5T/tssXhdGIC38gh6vg7r2LgUGEoYxhavJZ0UU5TC7TYPIX6RA=
Message-ID: <3d8471ca0802110528g16cad94y4351795527f3917@mail.gmail.com>
Date: Mon, 11 Feb 2008 14:28:58 +0100
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: rzryyvzy <rzryyvzy@trashmail.net>
Subject: Re: Help debugging filesystem activity?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080211131713.DC7435193B631@trashmail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080211131713.DC7435193B631@trashmail.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 11, 2008 2:17 PM, rzryyvzy <rzryyvzy@trashmail.net> wrote:
> $ cat /proc/fs/vfs/reading_files
>
> $ cat /proc/fs/vfs/writing_files

You can try:

# echo 1 > /proc/sys/vm/block_dump
# dmesg

HTH.

-- 
Guillaume
