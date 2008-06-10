Return-Path: <linux-kernel-owner+w=401wt.eu-S1760217AbYFJW01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217AbYFJW01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 18:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756525AbYFJW0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 18:26:16 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:42065 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756347AbYFJW0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 18:26:15 -0400
Date: Wed, 11 Jun 2008 00:26:13 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Tim Bird <tim.bird@am.sony.com>
cc: Sam Ravnborg <sam@ravnborg.org>,
       =?UTF-8?Q?J=C3=B6rn_Engel?= <joern@logfs.org>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: execute bit on scripts (was Re: [PATCH] add diffconfig
 utility)
In-Reply-To: <484EF323.7000809@am.sony.com>
Message-ID: <alpine.LNX.1.10.0806110025220.20733@fbirervta.pbzchgretzou.qr>
References: <484ED902.9040000@am.sony.com> <20080610210217.GA2432@logfs.org> <20080610211841.GA23855@uranus.ravnborg.org> <484EF323.7000809@am.sony.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2008-06-10 23:33, Tim Bird wrote:
>
>> I take most of the random scripts in scripts/ via kbuild.git.
>
>OK - sounds like you're the right person to ask a question
>that has been nagging me.
>
>Is there a proper way to get the execute bit set in the git tree
>on  patches that contain scripts?  I think patches
>produced by git have something that sets the file permissions?

If the patch was produced with git it should have a line like
	new file mode 100755

