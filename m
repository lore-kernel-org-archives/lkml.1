Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbYLCX1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbYLCX1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 18:27:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbYLCX1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 18:27:42 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:14115 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbYLCX1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 18:27:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=q8hQI+h6t2A/zqpBSHzvZTe8D4jfKIN1TTToxfTwbA1k2t2/U370iXGoWgIM5uBEqu
         E5wkyNZH5uySjjzc0pNVF9l5DRv8lFvNuLEFyUSc/FbKI3MePCpnfZ1nUvZgxFKhRmh1
         MjNLSLWzhZEfeS2bVGLl4oR1UbHTkxPR38zHI=
Message-ID: <804dabb00812031527k3fae11dcnef3b1696c3d136f8@mail.gmail.com>
Date: Thu, 4 Dec 2008 07:27:39 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: "Geoffrey McRae" <geoff@rabidhost.com>
Subject: Re: New Security Features, Please Comment
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Nick Andrew" <nick@nick-andrew.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20081203230820.4473a162@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1228260494.24232.21.camel@compy.ivent.com.au>
	 <20081203005338.6472db7a@lxorguk.ukuu.org.uk>
	 <1228268657.6679.4.camel@lappy.spacevs.com>
	 <20081203124252.GD11807@mail.local.tull.net>
	 <1228344292.6993.27.camel@lappy.spacevs.com>
	 <20081203230820.4473a162@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2008 at 7:08 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> The children are pre-forked, so the overhead is in the setup... then
>> when the app recieves a request, it sets the child's uid to the uid of
>> the website, and then passes the request to the child, which, now, the
>> child is running as the website owner.
>
> But the child process may already have been trojanned by a previous user
> so it gains you nothing.
>

Yes, I thought so too.   The trojanized child, even though most of the
time unprivileged, can wait for that window of opportunity when its
privilege is escalated, by polling, and when it received the
privilege, immediate jump into action.

Thanks.

-- 
Regards,
Peter Teoh

Ernest Hemingway - "Never mistake motion for action."
