Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbZCEMPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbZCEMPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 07:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907AbZCEMOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 07:14:37 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:58412 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892AbZCEMOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 07:14:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=EypP2+QwT11vGLnxcBgly5zdXGbmWxl56qNGrRyXkoXqKkKz7+GVFKZDYshSuLD0a+
         LcgxaK0IAcckkovU/0cI06HViwh6KNcdbGS9PwCAO01oPXylw4ZD6hHcFA1wcIsUoMEL
         33Did07NmVXxCC+/z09xNVb7rcECr6Nxy+Iq0=
Message-ID: <49AFC206.9080004@panasas.com>
Date: Thu, 05 Mar 2009 14:13:58 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: um: WARNING: vmlinux: 'memcpy' exported twice. Previous export was
 in vmlinux
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On today's linus v2.6.29-rc7-3-g559595a

Doing make ARCH=um defconfig & make ARCH=um
give's me:

LD vmlinux.o
MODPOST vmlinux.o
WARNING: vmlinux: 'memcpy' exported twice. Previous export was in vmlinux


Sorry if this is a duplicate report

Boaz

