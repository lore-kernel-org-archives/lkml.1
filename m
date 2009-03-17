Return-Path: <linux-kernel-owner+w=401wt.eu-S1760992AbZCQFet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760992AbZCQFet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 01:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbZCQFej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 01:34:39 -0400
Received: from mail-gx0-f163.google.com ([209.85.217.163]:45980 "EHLO
	mail-gx0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbZCQFej convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 01:34:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=dNkz4TBDtedX0ert6mMceEeJzKUe8lVm4/ImZkhFXjXrwkhwhCCYu/XfCF/kIY260N
         l/sLnqu2oTK0kQQTw0SfqqnvTsWLeRaFBv2fbu5lqwJ3o+eumuX7KkpmrJp6ubdqRfk2
         zlsRpyo4pNsavvtZ1Mg0rijwLiC+UZZiKDjws=
MIME-Version: 1.0
In-Reply-To: <bc9165390903162233o48e02d94v6bb216e5d68d9e77@mail.gmail.com>
References: <bc9165390903160912u79693a1dve975f559bfab103e@mail.gmail.com>
	 <bc9165390903162233o48e02d94v6bb216e5d68d9e77@mail.gmail.com>
Date: Tue, 17 Mar 2009 11:04:36 +0530
Message-ID: <bc9165390903162234maedd4d0l7026d8f53a1859cc@mail.gmail.com>
Subject: Re: Serial Flow Control
From: Rocker Dude <life.does.rock@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I am using a powerpc8548e custom hardware and testing flow control on
it. I have cross-wired the RTS/CTS of the board with my host terminal.
I find that when I am reading from the powerpc, it does not change the
CTS signal when it is running out of buffers and hence it is dropping
bytes.

I referred to something similar at http://lkml.org/lkml/2007/7/26/46.

Can anyone please tell me if this flow control needs to be done by the SW?

thanx!
Sundar
