Return-Path: <linux-kernel-owner+w=401wt.eu-S1764290AbZAUIvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764290AbZAUIvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 03:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763930AbZAUIuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 03:50:22 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:52905 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763881AbZAUIuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:50:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=JR/wRrDnfuLJ5gjHAv76IhiJ+IY4H2DXGCnX+gcuZaYqkiNRUdx4StHkxQYUV0WnGj
         va4XCCzFU1X0STaZq+LtQ+GjJS9aAH7jQMsJN2hJW5rouvI70c5RMavfRIHb4m+2nWQy
         aSbnDnYpq4TOs3+giq8Rugjb3nKK/o01sK0oc=
Date: Wed, 21 Jan 2009 11:49:29 +0300 (EAT)
From: Dan Carpenter <error27@gmail.com>
X-X-Sender: dcarpenter@bikeee
To: Andi Kleen <andi@firstfloor.org>
cc: Dan Carpenter <error27@gmail.com>, linux-kernel@vger.kernel.org,
       hannes@saeurebad.de
Subject: Re: emacs indenting howto
In-Reply-To: <87fxjddys0.fsf@basil.nowhere.org>
Message-ID: <alpine.DEB.2.00.0901211145370.4514@bikeee>
References: <alpine.DEB.2.00.0901191521270.2904@bikeee> <87fxjddys0.fsf@basil.nowhere.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2009, Andi Kleen wrote:
> Dan Carpenter <error27@gmail.com> writes:
>
>> I don't think emacs understands tilda expansion.  It didn't work for me.
>
> It does when you use expand-file-name
>
> -Andi

No problem.  Here is the updated patch.

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/Documentation/CodingStyle	2009-01-21 11:06:56.000000000 +0300
+++ devel/Documentation/CodingStyle	2009-01-21 11:01:35.000000000 +0300
@@ -488,7 +488,8 @@
              (let ((filename (buffer-file-name)))
                ;; Enable kernel mode for the appropriate files
                (when (and filename
-                         (string-match "~/src/linux-trees" filename))
+                         (string-match (expand-file-name "~/src/linux-trees")
+                              filename))
                  (setq indent-tabs-mode t)
                  (c-set-style "linux")
                  (c-set-offset 'arglist-cont-nonempty
