Return-Path: <linux-kernel-owner+w=401wt.eu-S1753775AbYCRHzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbYCRHzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 03:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbYCRHzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 03:55:38 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:15628 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbYCRHzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 03:55:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Uw6pys+MGlJTjldg6cUnEdTqaAUnD+VLeoOU2KLag60soZr/A+yOjhHC9EXi9GlDPLWnyfnmu/2MwwXZNONMgPclvVjH4hnMFQclVM1zdMa16HtX8Y2XmDTb5zfWfGtuKCnkOMaXmW9AzRe2c6MmaDb+L5pSqVgiGZjH6QqYrTc=
Message-ID: <dd18b0c30803180055w195aa088qd99f536eb63760e7@mail.gmail.com>
Date: Tue, 18 Mar 2008 07:55:36 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: capabillty.h
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello; I've tested this out by using an old 2.6.17 capability.h file
from the net, and yes it does work, but then you are confronted with :
=

Symbol init_mm is marked as USED, however the module is using it.
fglrx: unknown symbol change_page_attr {then goes into pci being deprecated};

from advice from SELinux it seems the module was built for 32bit
capabilities not 64bit capabilities. (or whatever the bit is)
So with this in mind how hard is it to go through and adjust the files
to work with the new capability?
{I've put cap_isclear in place of cap_t on 1888 at firegl_public.c
which did seem to resolve the issue of KCL, but was unable to
KCL_PosixSecuritySetEffectiveVector};


-- 
Justin P. Mattock
