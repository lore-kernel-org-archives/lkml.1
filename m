Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbYHCEUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbYHCEUV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 00:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbYHCEUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 00:20:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:53487 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbYHCEUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 00:20:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=OH8u/l8qDto5CWxkt2rHWYILocQmGCbNGs8HJTgF+69+lN2JyZ3xZq8394KcNuPJ01
         5rDUMT4tI0EQY3K8z0fT5dNxo2ksXvB6GRqCCyFbJZIefSjMn+UpcFRpSsOirt6pb2ci
         dvEqbGXia8Nw+O8qneU6Dk7IU+TcaCaoRKGwc=
Message-ID: <a32c680e0808022120g6cec9061k435ac20780583120@mail.gmail.com>
Date: Sun, 3 Aug 2008 00:20:05 -0400
From: Chris <kavefish@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Process Status Callback to Module
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I need a spot of help and I'm hoping someone can set me straight.  I'm
working on a module that keeps state about a small number of
processes.  Each time one of those processes exit, the module should
purge the corresponding state and I'm struggling to find a nice way to
do that.  Is there an existing callback mechanism to kick the module
with notification upon a process exit?  I've briefly read about the
connector project, but AFAIK that's geared to notify userspace rather
than a kernel module.  Any pointers would be greatly appreciated.

If replying, kindly CC my address directly b/c I'm not subscribed to the list.

Cheers,
Chris
