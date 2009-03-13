Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbZCMKXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbZCMKXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 06:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755625AbZCMKXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 06:23:33 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:24548 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757959AbZCMKXc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 06:23:32 -0400
Message-Id: <49BA3EEC.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 13 Mar 2009 10:09:32 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "Ian Campbell" <ian.campbell@citrix.com>,
       "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 23/24] xen: use device model for
	 suspendingxenbus devices
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>
 <1236931920-6861-24-git-send-email-jeremy@goop.org>
In-Reply-To: <1236931920-6861-24-git-send-email-jeremy@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 13.03.09 09:11 >>>

Shouldn't this also include removing the explicit calls to
gnttab_{suspend,resume}() in favor of making gnttab a sysdev?

Jan

