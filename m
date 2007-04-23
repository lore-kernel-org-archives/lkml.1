Return-Path: <linux-kernel-owner+w=401wt.eu-S932309AbXDWOM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbXDWOM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 10:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932231AbXDWOM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 10:12:28 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:63678 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409AbXDWOM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 10:12:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Hun7HG47L42wjRbXU3y+Vflw2kxZRNgLG8NSV4mCtmz4xq3v3/th31oqshh7gSXlGH6wWvPozsdgrvjMUJXfCnnO3Dr0IQQCvDzzYxXQJ5hn2Bnvic4FyQpI/a8cg3+uphTng/GLnhlQLhlRZmoJT33ii9aixkXIMnHTmNyx2UU=
Message-ID: <5a04609e0704230712i1d4aeeb8ke9d8649e167eebe9@mail.gmail.com>
Date: Mon, 23 Apr 2007 17:12:23 +0300
From: "Sergey Yanovich" <ynvich@gmail.com>
To: "Alex Dubov" <oakad@yahoo.com>
Subject: Re: [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
Cc: linux-kernel@vger.kernel.org, "Matthew Garrett" <mjg59@srcf.ucam.org>
In-Reply-To: <90215.57597.qm@web36713.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5a04609e0704230029x56f08654v9d9d3fb1fef414ee@mail.gmail.com>
	 <90215.57597.qm@web36713.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> SUBSYSTEM=="tifm", ACTION=="add", TIFM_CARD_TYPE=="SD", RUN+="/sbin/modprobe tifm_sd"

Thanks.

> As a side note: I have some very good reasons for the current driver architecture. You may want to
> look them up in the mail archive (I outlined them during the initial driver submission).

I am not in any way argue that your driver architecture is wrong or that you
should change anything. My point was simple. [tifm_sd] can only work with
[tifm_7xx1]. If you add support for let's say [tifm_8xx2] in the future, which
would have port offsets different that [tifm_7xx1], you would also need a
completely new modules for slots (sd, ms, etc).

--
Sergey Yanovich
