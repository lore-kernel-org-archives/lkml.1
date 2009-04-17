Return-Path: <linux-kernel-owner+w=401wt.eu-S1760026AbZDQGnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760026AbZDQGnH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 02:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbZDQGmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 02:42:53 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:61711 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757605AbZDQGmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 02:42:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=tmM6gLO2HR/UXAVxUpyX/O1Aaxnrtt3ZLqF4WKesfeONo9OhZi7j4hG3S7Cohhul+s
         PgsYPpnEBfdMRK74BaK1NL/ZbimWw/458GKU8As12grAkm2JS0kbG0LCVZvJ9+PuAG85
         4jg5piV1ichq3mNAAHhcRXM9Twx90pZwADaAE=
Message-ID: <49E824D5.4040204@gmail.com>
Date: Fri, 17 Apr 2009 08:42:29 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: "linux.kernel" <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>
Subject: blank screen on resume (recoverable)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In all recent kernels (up to 2.6.30-rc2) I have a blank screen on resume
after suspending to disk, it is recoverable in that everything starts
working as soon as I press a keyboard key _and_ touch the synaptic pad
of my W500 Thinkpad.

I've also had the same when suspending to disk on the console, so this
does not seem related to i915 or Xorg.

I thought I would bisect this trying 2.6.27 - 2.6.28, I suspect that
2.6.27 was still okay - but the problem is that I'm now using EXT4 for
my root file-system, and I get a panic on boot with  "cannot handle
large files.... CONFIG_LSF is not set"  or something like this.

It seems this option is to handle TB sized files, and I only have a
200GB laptop drive. Can I enable the option (though it seems obviously
wrong to me), or is going back so far into EXT4 history a bad idea?

Niel
