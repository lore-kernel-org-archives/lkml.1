Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbYE3DVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbYE3DVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 23:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbYE3DVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 23:21:34 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45894 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752394AbYE3DVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 23:21:33 -0400
X-Sasl-enc: ondAJgOQKSDKr4dtiskd9a22Ljkma/ICzIk1PpRrI8zD 1212117692
Date: Fri, 30 May 2008 00:21:30 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] acpi: fix sparse const errors
Message-ID: <20080530032130.GA3428@khazad-dum.debian.net>
References: <1212108717.28403.165.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212108717.28403.165.camel@brick>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008, Harvey Harrison wrote:
> In this case we want a constant pointer to constant chars:
> drivers/misc/thinkpad_acpi.c:3824:19: error: Just how const do you want this type to be?
> 
> Like the error says.
> drivers/misc/thinkpad_acpi.c:3863:19: error: Just how const do you want this type to be?
> drivers/misc/thinkpad_acpi.c:3864:19: error: Just how const do you want this type to be?
> drivers/misc/thinkpad_acpi.c:3865:19: error: Just how const do you want this type to be?
> drivers/misc/thinkpad_acpi.c:3866:19: error: Just how const do you want this type to be?
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
