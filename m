Return-Path: <linux-kernel-owner+w=401wt.eu-S1764239AbXGaPun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764239AbXGaPun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 11:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbXGaPud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 11:50:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:2381 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726AbXGaPuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 11:50:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=TXiXqMa2h55vV5nK/LbMTGP6OCYJmFQeHJSDE46F2afIo4KH2cpcHpOMKvUrgSE78DJaWikaSAdZ2BrS4Zr2HrYKf//lxCuzfT122o48IpIlUC3rWYaUzSN4EhRZSdwnzFNH7WagT6TuV5yxw8BnjRAeOBd+M+xz4vy8G4hrK1g=
Message-ID: <2c0942db0707310850n5b30987di5fe9c9c91eb525d6@mail.gmail.com>
Date: Tue, 31 Jul 2007 08:50:31 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: trelane@digitasaru.net, "Al Viro" <viro@ftp.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: inotify and /proc/<pid>
In-Reply-To: <20070731032521.GD6812@digitasaru.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070731021615.GB6812@digitasaru.net>
	 <20070731031720.GF21089@ftp.linux.org.uk>
	 <20070731032521.GD6812@digitasaru.net>
X-Google-Sender-Auth: 161aecf9669600f8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/30/07, Joseph Pingenot <trelane@digitasaru.net> wrote:
> What's the way to check for a process exiting without spinning?

I think you can get it from the taskstats interface, though I haven't
tried it. See Documentation/accounting/ for details.

Ray
