Return-Path: <linux-kernel-owner+w=401wt.eu-S1755852AbXKWE1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852AbXKWE1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 23:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbXKWE1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 23:27:17 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:53331 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbXKWE1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 23:27:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=STG5zx/pnJ7oUD6WTdmEsq23CsNpJCJI2rh0L7oViZdR83ooMrvPq/I5mfh1KGrOmR4LKv2856Sl1gq3wrBfmlR7V3KY6JiNpQPv9Y9obdKbTPF8S8lbTKOc4fr5648bruTZGP+ZF9VGaF9VWcwj/fVx+DvPpCqa11kuz80m258=
Message-ID: <3a9a77470711222027lc7e6bfbq8c54cea0d8420d0d@mail.gmail.com>
Date: Fri, 23 Nov 2007 09:57:16 +0530
From: TEJ <tej.linuxdev@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Chelsio driver bug in offload mode
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hey
I am using chelsio offload stack to tranfer data between two back to
back connected systems.
Now I using lighttpd server and http browser. After three-way
handskahe successful completed, when it start transfering of data it
gives me the following warning and then close the socket.

cxgb3 0000:01:00.0 CIM SDRAM address out of range (0x2)
cxgb3 0000:01:00.0 encountered fatal error. operation suspended.
cxgb3 0000:01:00.0 FW status: 0x0,0x0,0x0,0x0

n then i don't get anything on the browser side.

As i have tried to debug the problem i found that when skb is
nonlinear and skb->len became more then mtu, it give me this bug.
After that i have tried to linearize the skb and send but other side
it shows me a really html crapped data.

i am not able to clearly debug the problem. what i am doing wrong.

thanks
