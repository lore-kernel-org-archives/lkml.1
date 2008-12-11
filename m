Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbYLKLkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbYLKLkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 06:40:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbYLKLkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 06:40:11 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:5456 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014AbYLKLkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 06:40:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=tqExkv5iudNzNlo9cXXGtvrzac6g11lDDpo+RPNTL3YvsAbn68nH1hCNICBZWAWSGv
         Z3WxRW/rlC+d+Oro4be/sZ1l5KgNTqkgn7kODl+OmlpP+iPvpsX64bs0o0CalAFK5Fwb
         fK2robjb543xmkiTHvHP/FYZJQD9i+BIYo2v4=
Message-ID: <ca992f110812110340k53981469y5710209faeabce4b@mail.gmail.com>
Date: Thu, 11 Dec 2008 20:40:08 +0900
From: "junjie cai" <junjiec@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [RT] preempt_disable() in rt_up() not necessary?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear List,

I think the preempt_disable() in rt_up() is not necessary.
The highprio trylock-er would still get into infinite loop
if it keep trying without giving the lock holder a chance to release the lock.
I think the user should take care of that.

What do you think?

Thanks.

-- 
/*
 * Junjie Cai (junjiec@gmail.com)
 */
