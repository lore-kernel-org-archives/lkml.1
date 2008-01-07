Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbYAGJRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbYAGJRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 04:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbYAGJR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 04:17:29 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:30722 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbYAGJR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 04:17:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=O5zS2NAx9qZbzr3DXbZJv7zt5a5gucsOTMTW68nnG+eXEFqLn2VG3erXI2Wv15/ACMaAumgS5qDQBIYl0+eBMkq9GG6mmc9P32uTwM+pxO/CtdhWkhgv+BQ3LAzgpw6JtyEsL+ZFbDxq8GPuYQ05PJoMHhusMr7IFdkhWfGG0Y8=
Message-ID: <4781EE20.6070701@gmail.com>
Date: Mon, 07 Jan 2008 18:17:20 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Gabor Gombas <gombasg@sztaki.hu>,
       Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, Greg KH <greg@kroah.com>
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
References: <20071228173203.GA20690@boogie.lpds.sztaki.hu>	<a8e1da0712290007o168a730cw923055ad2c265d84@mail.gmail.com>	<20080102151642.GA7273@boogie.lpds.sztaki.hu>	<20080105075039.GF27894@ZenIV.linux.org.uk>	<477F9481.2040505@gmail.com>	<20080105194510.GK27894@ZenIV.linux.org.uk>	<478037F8.8020103@gmail.com> <47819079.3000606@gmail.com> <m1abnikpuz.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1abnikpuz.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>> That said, the mechanism is a bit too fragile.  sysfs currently ensures
>> that dentry/inode point to the associated sysfs_dirent.  This is mainly
>> remanent of conversion from previous VFS based implementation.  I think
>> the right thing to do here is to make sysfs behave like other proper
>> distributed filesystems using d_revalidate.
> 
> Huh?  We still need something like sysfs_get_dentry to find the dentries
> for the rename or move operation.  So we can call d_move.  

Ah... right.  Thanks.  :-)

-- 
tejun
